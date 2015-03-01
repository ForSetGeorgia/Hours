class Project < ActiveRecord::Base
  attr_accessible :name, :organization_id, :active

  belongs_to :organization
  has_many :timestamps
end
