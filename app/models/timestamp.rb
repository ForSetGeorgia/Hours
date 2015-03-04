class Timestamp < ActiveRecord::Base
  attr_accessible :diff_level, :duration, :notes, :project_id, :user_id, :stage_id

  belongs_to :project
  belongs_to :stage
  belongs_to :user

  DIFF_LEVELS = ["Easy", "Moderately Easy", "Medium", "Difficult", "Very Difficult"]

  scope :stamps_today, -> { where('timestamps.created_at >= ?', Time.zone.now.beginning_of_day) }
  scope :sorted, includes(:project).order('timestamps.created_at desc, projects.name asc')

  validates :project_id, :diff_level, :stage_id, :duration, :user_id, :presence => true
end
