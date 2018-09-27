class SubtaskSerializer < ActiveModel::Serializer
  attributes :id, :task, :task_type, :points
  has_one :story
end
