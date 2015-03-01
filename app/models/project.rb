class Project < ActiveRecord::Base
  attr_accessible :name, :organization_id, :active

  belongs_to :organization
  has_many :timestamps

  scope :active?, where(active: true)

  def name_with_proj
    "#{organization.short_name}: #{name}"
  end
  	
end
