class ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_one :user
  has_many :epic, :key => 'epics'
  has_many :story, through: :epic, :key => 'stories'
end
