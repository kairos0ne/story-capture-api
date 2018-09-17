class EpicSerializer < ActiveModel::Serializer
  attributes :id, :name, :summary
  has_one :client
  has_many :story, :key => 'stories'
end
