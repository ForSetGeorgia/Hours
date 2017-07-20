class Activity < ActiveRecord::Base

  ###############################
  ## RELATIONSHIPS
  belongs_to :project
  belongs_to :project_type
  has_many :timestamps, dependent: :destroy


  ###############################
  ## ATTRIBUTES
  attr_accessible :id, :name, :project_type_id, :active, :notes


  ###############################
  ## VALIDATIONS
  validates :name, :project_id, :project_type_id, :presence => true

  ###############################
  ## SCOPES
  scope :is_active, where(active: true)

  ###############################
  ## METHODS
  def full_name
    "#{name} (#{project_type.name})"
  end

  def full_name_with_project
    "#{project.full_name} - #{full_name}"
  end

end
