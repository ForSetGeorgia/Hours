class Timestamp < ActiveRecord::Base
  attr_accessible :diff_level, :duration, :notes, :project_id, :user_id

  belongs_to :project
  belongs_to :user

  DIFF_LEVELS = ["Easy", "Moderately Easy", "Medium", "Difficult", "Very Difficult"]

  scope :stamps_today, -> { where('created_at <= ?', Time.zone.now.beginning_of_day) }
end
