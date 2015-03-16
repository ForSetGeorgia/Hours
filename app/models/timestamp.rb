class Timestamp < ActiveRecord::Base
  attr_accessible :user_id, :project_id, :stage_id, :duration, :diff_level, :notes, :date

  belongs_to :project
  belongs_to :stage
  belongs_to :user

  DIFF_LEVELS = ["Easy", "Moderately Easy", "Medium", "Difficult", "Very Difficult", "Not Relevant"]
  SUMMARY = {user: 1, project: 2, date: 3}

  scope :stamps_today, -> { where('timestamps.date >= ?', Time.zone.now.beginning_of_day) }
  scope :sorted, includes(:project).order('timestamps.date desc, projects.name asc')

  validates :date, :project_id, :diff_level, :stage_id, :duration, :user_id, :presence => true


  ######################

  # get for a user
  def self.by_user(user_id)
    where('timestamps.user_id = ?', user_id)
  end

  # get for a project
  def self.by_project(project_id)
    where('timestamps.project_id = ?', project_id)
  end

  # get for a date
  def self.by_date(date)
    where('timestamps.date = ?', date)
  end

  # get dates
  def self.dates
    pluck(:date).uniq.sort.map{|x| x.to_s}
  end

  # get first date on file
  def self.start_date
    select('date').order('date').map{|x| x.date}.first
  end

  # get last date on file
  def self.end_date
    select('date').order('date desc').map{|x| x.date}.first
  end

  ######################

  # get all activity for teh current day
  def self.current_day_stamps
    process_user_data_for_charts(where('timestamps.date >= ?', Time.zone.now.beginning_of_day).sorted)
  end

  # get all activity by day
  def self.all_stamps(options={})
    query = sorted
    query = query.where('timestamps.date >= ?', options[:start_at]) if options[:start_at].present?
    query = query.where('timestamps.date <= ?', Date.parse(options[:end_at])+1.day) if options[:end_at].present?

    if options[:type] == Timestamp::SUMMARY[:project]
      process_project_data_for_charts(query)
    else
      process_user_data_for_charts(query)
    end
  end


  private

  # process the data for the passed in records so is ready for charting
  # returns hash of the following:
  # - projects: array of {name: ___, data: [], y:___}
  #   - data = array of sum of duration for project for each date
  #   - y = overall sum of all durations for this project
  # - dates: array of unique dates
  # - dates_formatted: array of unique dates in format: Day yyyy-mm-dd
  # - records: the records that were passed in
  # - counts: hash of total counts {dates: xx, projects: xx, hours: xx}
  def self.process_user_data_for_charts(records)
    stamps = {projects: [], dates: [], dates_formatted: [], records: records, counts: {projects: 0, dates: 0, hours: 0}}
    template = {name: nil, data: nil, y:nil}

    if records.present?
      # group by dates
      dates = records.group_by{|x| x.date}
      stamps[:dates] = dates.keys.map{|x| x.to_s}
      stamps[:dates_formatted] = dates.keys.map{|x| I18n.l(x, format: :chart_axis)}

      # get the unique projects
      projects = records.map{|x| x.project}.uniq.sort_by{|x| x.full_name}
      # for each project, record data for each date
      total_hours = 0
      projects.each do |project|
        puts "project = #{project.id}"
        project_data = template.dup
        project_data[:name] = project.full_name
        project_data[:data] = []
        project_data[:y] = ((records.select{|x| x.project_id == project.id}.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
        dates.keys.each do |date|
          puts "- date = #{date}; projects on this date = #{dates[date].length}"
          date_projects = dates[date].select{|x| x.project_id == project.id}
          puts "-- date projects = #{date_projects.inspect}"
          if date_projects.present?
            puts "--- adding #{date_projects.map{|x| x.duration}}"
            project_data[:data] << ((date_projects.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
          else
            puts "--- adding 0"
            # no data for this project on this date
            project_data[:data] << 0
          end
        end
        stamps[:projects] << project_data
        total_hours += project_data[:data].inject(:+)
      end

      # add the counts
      stamps[:counts][:projects] = stamps[:projects].length
      stamps[:counts][:dates] = stamps[:dates].length
      stamps[:counts][:hours] = total_hours.round(2)
    end

    return stamps
  end


  # process the data for the passed in records so is ready for charting
  # returns hash of the following:
  # - users: array of {name: ___, data: [], y:___}
  #   - data = array of sum of duration for project for each date
  #   - y = overall sum of all durations for this project
  # - dates: array of unique dates
  # - dates_formatted: array of unique dates in format: Day yyyy-mm-dd
  # - records: the records that were passed in
  # - counts: hash of total counts {dates: xx, projects: xx, hours: xx}
  def self.process_project_data_for_charts(records)
    stamps = {users: [], dates: [], dates_formatted: [], records: records, counts: {users: 0, dates: 0, hours: 0}}
    template = {name: nil, data: nil, y:nil}

    if records.present?
      # group by dates
      dates = records.group_by{|x| x.date}
      stamps[:dates] = dates.keys.map{|x| x.to_s}
      stamps[:dates_formatted] = dates.keys.map{|x| I18n.l(x, format: :chart_axis)}

      # get the unique users
      users = records.map{|x| x.user}.uniq.sort_by{|x| x.nickname}
      # for each user, record data for each date
      total_hours = 0
      users.each do |user|
        puts "user = #{user.id}"
        user_data = template.dup
        user_data[:name] = user.nickname
        user_data[:data] = []
        user_data[:y] = ((records.select{|x| x.user_id == user.id}.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
        dates.keys.each do |date|
          puts "- date = #{date}; users on this date = #{dates[date].length}"
          date_users = dates[date].select{|x| x.user_id == user.id}
          puts "-- date users = #{date_users.inspect}"
          if date_users.present?
            puts "--- adding #{date_users.map{|x| x.duration}}"
            user_data[:data] << ((date_users.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
          else
            puts "--- adding 0"
            # no data for this user on this date
            user_data[:data] << 0
          end
        end
        stamps[:users] << user_data
        total_hours += user_data[:data].inject(:+)
      end

      # add the counts
      stamps[:counts][:users] = stamps[:users].length
      stamps[:counts][:dates] = stamps[:dates].length
      stamps[:counts][:hours] = total_hours.round(2)
    end

    return stamps
  end

end
