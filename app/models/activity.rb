class Activity < ActiveRecord::Base

  ###############################
  ## RELATIONSHIPS
  belongs_to :project
  belongs_to :project_type
  has_many :timestamps, dependent: :destroy


  ###############################
  ## ATTRIBUTES
  attr_accessible :name


  ###############################
  ## VALIDATIONS
  validates :name, :project_id, :project_type_id, :presence => true

end
