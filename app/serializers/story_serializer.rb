class StorySerializer < ActiveModel::Serializer
  attributes :id, :task, :story_type, :points
  has_one :epic
end
