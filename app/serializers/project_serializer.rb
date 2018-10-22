class ProjectSerializer < ActiveModel::Serializer
  attributes :key, :name, :id, :avatarUrls
end
