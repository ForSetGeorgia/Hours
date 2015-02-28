class Timestamp < ActiveRecord::Base
  attr_accessible :diff_level, :duration, :notes, :project_id, :user_id

  belongs_to :project
  belongs_to :user
end
