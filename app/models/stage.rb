class Stage < ActiveRecord::Base
  attr_accessible :id, :name, :sort_order

  has_many :timestamps

  scope :sorted, order('sort_order asc, name asc')

  validates :name, :presence => true

end
