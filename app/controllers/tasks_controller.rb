# app/controllers/api/tasks_controller.rb

module Api
    class TasksController < ApplicationController
      before_action :set_task, only: [:show, :update, :destroy, :assign, :progress]
  
      # GET /api/tasks
      def index
        @tasks = Task.all
        render json: @tasks
      end
  
      # GET /api/tasks/:id
      def show
        render json: @task
      end
  
      # POST /api/tasks
      def create
        @task = Task.new(task_params)
        if @task.save
          render json: @task, status: :created
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end
  
      # PUT /api/tasks/:id
      def update
        if @task.update(task_params)
          render json: @task
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end
  
      # DELETE /api/tasks/:id
      def destroy
        @task.destroy
      end
  
      # POST /api/tasks/:id/assign
      def assign
        @user = User.find(params[:user_id])
        @task.update(user: @user)
        render json: @task
      end
  
      # PUT /api/tasks/:id/progress
      def progress
        @task.update(progress_params)
        render json: @task
      end
  
      # GET /api/tasks/overdue
      def overdue
        @tasks = Task.where('due_date < ?', Date.today)
        render json: @tasks
      end
  
      # GET /api/tasks/status/:status
      def by_status
        @tasks = Task.where(status: params[:status])
        render json: @tasks
      end
  
      # GET /api/tasks/completed
      def completed_tasks
        @tasks = Task.where(status: 'Completed', completed_date: params[:start_date]..params[:end_date])
        render json: @tasks
      end
  
      # GET /api/tasks/statistics
      def statistics
        total_tasks = Task.count
        completed_tasks = Task.where(status: 'Completed').count
        percentage_completed = (completed_tasks.to_f / total_tasks * 100).round(2)
        render json: { total_tasks: total_tasks, completed_tasks: completed_tasks, percentage_completed: percentage_completed }
      end
  
      # GET /api/users/:user_id/tasks
      def user_tasks
        @user = User.find(params[:user_id])
        @tasks = @user.tasks
        render json: @tasks
      end
  
      private
  
      def set_task
        @task = Task.find(params[:id])
      end
  
      def task_params
        params.require(:task).permit(:title, :description, :due_date, :status)
      end
  
      def progress_params
        params.require(:task).permit(:progress)
      end
    end
  end
  