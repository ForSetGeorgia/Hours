class Group < ActiveRecord::Base
  attr_accessible :active, :name, :project_ids

  has_and_belongs_to_many :projects

  validates :name, :active, :presence => true

  scope :is_active, where(active: true)
  scope :sorted, order('name asc')
end
