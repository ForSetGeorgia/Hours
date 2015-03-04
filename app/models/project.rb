class Project < ActiveRecord::Base
  attr_accessible :id, :name, :organization_id, :active, :project_type_id

  belongs_to :organization
  belongs_to :project_type
  has_many :timestamps, dependent: :destroy

  scope :is_active, where(active: true)
  scope :sorted, order('name asc')
  scope :sorted_organization, includes(:organization, :project_type).order('organizations.short_name asc, projects.name asc, project_types.name asc')

  validates :name, :organization_id, :project_type_id, :presence => true
  
  def full_name
    "#{organization.short_name}: #{name} (#{project_type.name})"
  end
  	
end
