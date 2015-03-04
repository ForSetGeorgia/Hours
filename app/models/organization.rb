class Organization < ActiveRecord::Base
  attr_accessible :id, :long_name, :short_name

  has_many :projects, dependent: :destroy

  scope :sorted_long_name, order('long_name asc')
  scope :sorted_short_name, order('short_name asc')

  validates :long_name, :short_name, :presence => true
end
