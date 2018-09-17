class Epic < ApplicationRecord
  validates :name,  :presence => true
  belongs_to :client
  has_many :story, :dependent => :destroy
end
