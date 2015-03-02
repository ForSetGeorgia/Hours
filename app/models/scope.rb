class Scope < ActiveRecord::Base
  attr_accessible :name, :sort_order

  has_many :timestamps

  scope :sorted, order('sort_order asc, name asc')

end
