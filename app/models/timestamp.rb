class Timestamp < ActiveRecord::Base
  attr_accessible :user_id, :activity_id, :stage_id, :duration, :diff_level, :notes, :date, :assignee, :parent_id
  attr_accessor :assignee
  belongs_to :activity
  belongs_to :stage
  belongs_to :user

  DIFF_LEVELS = ["Easy", "Moderately Easy", "Medium", "Difficult", "Very Difficult", "Not Relevant"]
  SUMMARY = {user: 1, project: 2, date: 3}

  scope :stamps_today, -> { where('timestamps.date >= ?', Time.zone.now.beginning_of_day) }
  scope :sorted, includes(activity: :project).order('timestamps.date desc, projects.name asc, activities.name asc')

  validates :date, :activity_id, :stage_id, :duration, :user_id, :presence => true


  ######################

  # get for a user
  def self.by_user(user_id)
    where('timestamps.user_id = ?', user_id)
  end

  # get for a project
  def self.by_project(project_id)
    joins(:activity).where('activities.project_id = ?', project_id)
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

  # get timestamps for the last week
  def self.for_last_week
    where(['timestamps.date between ? and ?', 1.week.ago.in_time_zone.to_date, Time.now.in_time_zone.to_date])
  end

  # get the list of user ids that have records today
  def self.has_records_today
    where("DATE(created_at) = '#{Time.now.to_date}'").pluck(:user_id).uniq
  end

  ######################
  def children
    Timestamp.where('parent_id = ?', self.id)
  end

  def parent
    Timestamp.where('id = ?', self.parent_id).first
  end

  def created_by
    has_parent? ? self.parent.user.nickname : self.user.nickname
  end

  def has_parent?
    self.parent_id.present?
  end

  # def parent?
  #   Timestamp.where('parent_id = ?', self.id).first.present?
  # end

  # def child?
  #   self.parent_id.present?
  # end

  # get all activity for the current day
  def self.current_day_stamps
    process_user_data_for_charts(stamps_today.sorted)
  end

  # get all activity by day
  def self.all_stamps(options={})
    query = sorted
    query = query.where('timestamps.date >= ?', options[:start_at]) if options[:start_at].present?
    query = query.where('timestamps.date <= ?', Date.parse(options[:end_at])+1.day) if options[:end_at].present?
    if options[:active_project].present? && options[:active_project]
      query = query.joins(:activity).where('activities.project_id in (select id from projects where active = ?)', true)
    end

    if options[:active_user].present? && options[:active_user]
      query = query.where('timestamps.user_id in (select id from users where active = ?)', true)
    end

    if options[:type] == Timestamp::SUMMARY[:project]
      process_project_data_for_charts(query)
    elsif options[:type] == Timestamp::SUMMARY[:date]
      process_date_data_for_charts(query)
    else
      process_user_data_for_charts(query)
    end
  end


  ######################
  def project
    activity.project
  end

  private

  # process the data for the passed in records so is ready for charting
  # returns hash of the following:
  # - projects: {chart_datea: []}
  # - activities: {chart_datea: []}
  # - xaxis_categories: [],
  # - xaxis_categories_alt: [],
  # - records,
  # - counts: {projects, activities, dates, hours}
  def self.process_user_data_for_charts(records)
    stamps = {projects: {chart_data: []}, activities: {chart_data: []},
              xaxis_categories: [], xaxis_categories_alt: [],
              records: records, counts: {projects: 0, activities: 0, dates: 0, hours: 0}}
    template = {name: nil, data: nil, y:nil}

    if records.present?
      # group by dates
      dates = records.group_by{|x| x.date}
      stamps[:xaxis_categories] = dates.keys.map{|x| I18n.l(x, format: :chart_axis)}
      stamps[:xaxis_categories_alt] = dates.keys.map{|x| x.to_s}

      # get the unique projects
      projects = records.map{|x| x.activity.project}.uniq.sort_by{|x| x.full_name}
      # for each project, record data for each date
      total_hours = 0
      projects.each do |project|
        puts "project = #{project.id}"
        project_data = template.dup
        project_data[:name] = project.full_name
        project_data[:data] = []
        project_data[:y] = ((records.select{|x| x.activity.project_id == project.id}.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
        dates.keys.each do |date|
          puts "- date = #{date}; projects on this date = #{dates[date].length}"
          date_projects = dates[date].select{|x| x.activity.project_id == project.id}
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
        stamps[:projects][:chart_data] << project_data
        total_hours += project_data[:data].inject(:+)
      end

      # get the unique activities
      activities = records.map{|x| x.activity}.uniq.sort_by{|x| x.full_name_with_project}
      # for each activity, record data for each date
      total_hours = 0
      activities.each do |activity|
        puts "activity = #{activity.id}"
        activity_data = template.dup
        activity_data[:name] = activity.full_name_with_project
        activity_data[:data] = []
        activity_data[:y] = ((records.select{|x| x.activity_id == activity.id}.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
        dates.keys.each do |date|
          puts "- date = #{date}; activities on this date = #{dates[date].length}"
          date_activities = dates[date].select{|x| x.activity_id == activity.id}
          puts "-- date activities = #{date_activities.inspect}"
          if date_activities.present?
            puts "--- adding #{date_activities.map{|x| x.duration}}"
            activity_data[:data] << ((date_activities.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
          else
            puts "--- adding 0"
            # no data for this activity on this date
            activity_data[:data] << 0
          end
        end
        stamps[:activities][:chart_data] << activity_data
        total_hours += activity_data[:data].inject(:+)
      end

      # add the counts
      stamps[:counts][:projects] = stamps[:projects][:chart_data].length
      stamps[:counts][:activities] = stamps[:activities][:chart_data].length
      stamps[:counts][:dates] = stamps[:xaxis_categories].length
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
    stamps = {users: {chart_data: []}, activities: {chart_data: []},
              xaxis_categories: [], xaxis_categories_alt: [],
              records: records, counts: {users: 0, activities: 0, dates: 0, hours: 0}}
    template = {name: nil, data: nil, y:nil}

    if records.present?
      # group by dates
      dates = records.group_by{|x| x.date}
      stamps[:xaxis_categories] = dates.keys.map{|x| I18n.l(x, format: :chart_axis)}
      stamps[:xaxis_categories_alt] = dates.keys.map{|x| x.to_s}

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
        stamps[:users][:chart_data] << user_data
        total_hours += user_data[:data].inject(:+)
      end

      # get the unique activities
      activities = records.map{|x| x.activity}.uniq.sort_by{|x| x.full_name_with_project}
      # for each activity, record data for each date
      total_hours = 0
      activities.each do |activity|
        puts "activity = #{activity.id}"
        activity_data = template.dup
        activity_data[:name] = activity.full_name_with_project
        activity_data[:data] = []
        activity_data[:y] = ((records.select{|x| x.activity_id == activity.id}.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
        dates.keys.each do |date|
          puts "- date = #{date}; activities on this date = #{dates[date].length}"
          date_activities = dates[date].select{|x| x.activity_id == activity.id}
          puts "-- date activities = #{date_activities.inspect}"
          if date_activities.present?
            puts "--- adding #{date_activities.map{|x| x.duration}}"
            activity_data[:data] << ((date_activities.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
          else
            puts "--- adding 0"
            # no data for this activity on this date
            activity_data[:data] << 0
          end
        end
        stamps[:activities][:chart_data] << activity_data
        total_hours += activity_data[:data].inject(:+)
      end
      # add the counts
      stamps[:counts][:users] = stamps[:users][:chart_data].length
      stamps[:counts][:activities] = stamps[:activities][:chart_data].length
      stamps[:counts][:dates] = stamps[:xaxis_categories].length
      stamps[:counts][:hours] = total_hours.round(2)
    end

    return stamps
  end

  # process the data for the passed in records so is ready for charting
  # returns hash of the following:
  # - projects: {chart_datea: []}
  # - activities: {chart_datea: []}
  # - xaxis_categories: [],
  # - xaxis_categories_alt: [],
  # - records,
  # - counts: {projects, activities, users, hours}
  def self.process_date_data_for_charts(records)
    stamps = {projects: {chart_data: []}, activities: {chart_data: []},
              xaxis_categories: [], xaxis_categories_alt: [],
              records: records, counts: {projects: 0, activities: 0, users: 0, hours: 0}}
    template = {name: nil, data: nil, y:nil}

    if records.present?
      # group by users
      users = records.group_by{|x| x.user.nickname}
      stamps[:xaxis_categories] = users.keys.sort.map{|x| x}
      stamps[:xaxis_categories_alt] = users.keys.sort.map{|x| x}

      # get the unique projects
      projects = records.map{|x| x.activity.project}.uniq.sort_by{|x| x.full_name}
      # for each project, record data for each date
      total_hours = 0
      projects.each do |project|
        puts "project = #{project.id}"
        project_data = template.dup
        project_data[:name] = project.full_name
        project_data[:data] = []
        project_data[:y] = ((records.select{|x| x.activity.project_id == project.id}.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
        users.keys.sort.each do |user|
          puts "- user = #{user}; projects for this user = #{users[user].length}"
          user_projects = users[user].select{|x| x.activity.project_id == project.id}
          puts "-- user projects = #{user_projects.inspect}"
          if user_projects.present?
            puts "--- adding #{user_projects.map{|x| x.duration}}"
            project_data[:data] << ((user_projects.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
          else
            puts "--- adding 0"
            # no data for this project on this date
            project_data[:data] << 0
          end
        end
        stamps[:projects][:chart_data] << project_data
        total_hours += project_data[:data].inject(:+)
      end

      # get the unique activities
      activities = records.map{|x| x.activity}.uniq.sort_by{|x| x.full_name_with_project}
      # for each activity, record data for each date
      total_hours = 0
      activities.each do |activity|
        puts "activity = #{activity.id}"
        activity_data = template.dup
        activity_data[:name] = activity.full_name_with_project
        activity_data[:data] = []
        activity_data[:y] = ((records.select{|x| x.activity_id == activity.id}.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
        users.keys.sort.each do |user|
          puts "- user = #{user}; activities for this user = #{users[user].length}"
          user_activities = users[user].select{|x| x.activity_id == activity.id}
          puts "-- user activities = #{user_activities.inspect}"
          if user_activities.present?
            puts "--- adding #{user_activities.map{|x| x.duration}}"
            activity_data[:data] << ((user_activities.inject(0){|sum,x| sum + x.duration }) / 60.0).round(2)
          else
            puts "--- adding 0"
            # no data for this activity on this date
            activity_data[:data] << 0
          end
        end
        stamps[:activities][:chart_data] << activity_data
        total_hours += activity_data[:data].inject(:+)
      end

      # add the counts
      stamps[:counts][:projects] = stamps[:projects][:chart_data].length
      stamps[:counts][:activities] = stamps[:activities][:chart_data].length
      stamps[:counts][:users] = stamps[:xaxis_categories].length
      stamps[:counts][:hours] = total_hours.round(2)

    end

    return stamps
  end

end
