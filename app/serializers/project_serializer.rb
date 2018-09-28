class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :project, :description
  has_one :client
end
