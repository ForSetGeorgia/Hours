class ProjectType < ActiveRecord::Base
  attr_accessible :name

  has_many :projects

  scope :sorted, order('name asc')

end
