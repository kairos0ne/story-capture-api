class Client < ApplicationRecord
  validates :name,  :presence => true
  belongs_to :user
  has_many :epic, :dependent => :destroy
  has_many :story, through: :epic
end
