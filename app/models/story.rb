class Story < ApplicationRecord
  validates :task,  :presence => true
  validates :story_type,  :presence => true
  belongs_to :epic
  has_many :subtask, :dependent => :destroy
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |story|
        csv << story.attributes.values_at(*column_names)
      end
    end
  end
end
