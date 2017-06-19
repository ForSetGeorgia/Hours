class ProjectType < ActiveRecord::Base
  attr_accessible :id, :name

  has_many :activities

  scope :sorted, order('name asc')

  validates :name, :presence => true

end
