class Project < ActiveRecord::Base
  attr_accessible :name, :organization_id, :active, :project_type_id

  belongs_to :organization
  belongs_to :project_type
  has_many :timestamps, dependent: :destroy

  scope :active?, where(active: true)
  scope :sorted, order('name asc')

  def name_with_proj
    "#{organization.short_name}: #{name}"
  end
  	
end
