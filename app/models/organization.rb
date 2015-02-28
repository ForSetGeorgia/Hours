class Organization < ActiveRecord::Base
  attr_accessible :long_name, :short_name

  has_many :projects
end
