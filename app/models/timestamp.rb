class Timestamp < ActiveRecord::Base
  attr_accessible :diff_level, :duration, :notes, :project_id, :user_id, :stage_id

  belongs_to :project
  belongs_to :stage
  belongs_to :user

  DIFF_LEVELS = ["Easy", "Moderately Easy", "Medium", "Difficult", "Very Difficult"]

  scope :stamps_today, -> { where('timestamps.created_at >= ?', Time.zone.now.beginning_of_day) }
  scope :sorted, includes(:project).order('timestamps.created_at desc, projects.name asc')

  validates :project_id, :diff_level, :stage_id, :duration, :user_id, :presence => true

  ######################

  # get for a user
  def self.by_user(user_id)
    where('timestamps.user_id = ?', user_id)
  end

  # get first date on file
  def self.start_date
    select('created_at').order('created_at').map{|x| x.created_at}.first
  end

  # get last date on file
  def self.end_date
    select('created_at').order('created_at desc').map{|x| x.created_at}.first
  end

  ######################

  # get all activity for teh current day
  def self.current_day_stamps
    process_data_for_charts(where('timestamps.created_at >= ?', Time.zone.now.beginning_of_day).sorted)
  end

  # get all activity for the current week, by day
  def self.current_week_stamps
    process_data_for_charts(where('timestamps.created_at between ? and ?', Time.zone.now.at_beginning_of_week, Time.zone.now.at_end_of_week).sorted)
  end

  # get all activity by day
  def self.all_stamps(options={})
    query = sorted
    query = query.where('timestamps.created_at >= ?', options[:start_at]) if options[:start_at].present?
    query = query.where('timestamps.created_at <= ?', Date.parse(options[:end_at])+1.day) if options[:end_at].present?

    process_data_for_charts(query)
  end


  private

  def self.process_data_for_charts(records)
    stamps = {projects: [], dates: [], records: records}
    template = {name: nil, data: nil}

    if records.present?
      dates = records.group_by{|x| x.created_at.to_date}
      stamps[:dates] = dates.keys.map{|x| x.to_s}

      projects = records.map{|x| x.project}.uniq.sort_by{|x| x.name}
      projects.each do |project|
        puts "project = #{project.id}"
        project_data = template.dup
        puts "- project data = #{project_data}"
        project_data[:name] = project.full_name
        project_data[:data] = []
        dates.keys.each do |date|
          puts "- date = #{date}; projects on this date = #{dates[date].length}"
          date_projects = dates[date].select{|x| x.project_id == project.id}
          puts "-- date projects = #{date_projects.inspect}"
          if date_projects.present?
            puts "--- adding #{date_projects.map{|x| x.duration}}"
            project_data[:data] << (date_projects.inject(0){|sum,x| sum + x.duration }) / 60.0
          else
            puts "--- adding 0"
            # no data for this project on this date
            project_data[:data] << 0
          end
        end
        stamps[:projects] << project_data
      end
    end

    return stamps
  end
end
