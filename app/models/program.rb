class Program < ActiveRecord::Base
  attr_accessible :active, :name

  has_many :projects, dependent: :destroy

  scope :is_active, where(active: true)
  scope :sorted, order('name asc')

  validates :name, :presence => true
end
