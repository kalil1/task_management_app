class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :due_date, :completed_date, :status, :user_id
end
