class Project < ActiveRecord::Base
  
  attr_accessible :description, :name, :organization_id, :active

  belongs_to :organization
  has_many :timestamps
end
