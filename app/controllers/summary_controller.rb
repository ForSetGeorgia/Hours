class SummaryController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:staff])
  end

  def index

  end

  def user
    @users = User.sorted
    records = nil
    begin_at = nil
    last_at = nil
    params[:timestamp_start_at] ||= 1.week.ago.in_time_zone.to_date.to_s
    params[:timestamp_end_at] ||= Time.zone.now.to_date.to_s
    params[:timestamp_user_id] ||= @users.first.id
    @user = @users.select{|x| x.id.to_s == params[:timestamp_user_id].to_s}.first

    if params[:active_projects].present?
      params[:active_projects] = params[:active_projects] == 'true'
    else
      params[:active_projects] = @default_active_projects_value
    end

    records = Timestamp.by_user(params[:timestamp_user_id]).all_stamps(start_at: params[:timestamp_start_at], end_at: params[:timestamp_end_at], active: params[:active_projects])
    dates = Timestamp.by_user(params[:timestamp_user_id]).dates

    # in app controller
    load_data_for_charts(records, dates, :projects, :dates, 'charts.summary.user', true, @user.nickname)

  end

  def project
    @projects = Project.sorted_organization
    records = nil
    begin_at = nil
    last_at = nil
    params[:timestamp_start_at] ||= 1.week.ago.in_time_zone.to_date.to_s
    params[:timestamp_end_at] ||= Time.zone.now.to_date.to_s
    params[:timestamp_project_id] ||= @projects.first.id
    @project = @projects.select{|x| x.id.to_s == params[:timestamp_project_id].to_s}.first

    if params[:active_projects].present?
      params[:active_projects] = params[:active_projects] == 'true'
    else
      params[:active_projects] = @default_active_projects_value
    end

    records = Timestamp.by_project(params[:timestamp_project_id]).all_stamps(start_at: params[:timestamp_start_at], end_at: params[:timestamp_end_at], type: Timestamp::SUMMARY[:project], active: params[:active_projects])
    dates = Timestamp.by_project(params[:timestamp_project_id]).dates

    # in app controller
    load_data_for_charts(records, dates, :users, :dates, 'charts.summary.project', true, @project.full_name)

  end

  def date
    dates = Timestamp.dates
    @dates_formatted = dates.map{|x| [I18n.l(Date.parse(x), format: :chart_axis), x]}
    records = nil
    begin_at = nil
    last_at = nil
    params[:timestamp_date] ||= dates.last
    params[:timestamp_date] = dates.last if params[:timestamp_date].present? && dates.index{|x| x == params[:timestamp_date]}.nil?
    date = dates.select{|x| x == params[:timestamp_date]}.first
    @date_formatted = date.present? ? I18n.l(Date.parse(date), format: :chart_axis) : date
    gon.timestamp_summary_date = date

    if dates.present?
      begin_at = dates.first
      last_at = dates.last
    end

    if params[:active_projects].present?
      params[:active_projects] = params[:active_projects] == 'true'
    else
      params[:active_projects] = @default_active_projects_value
    end

    records = Timestamp.by_date(params[:timestamp_date]).all_stamps(type: Timestamp::SUMMARY[:date], active: params[:active_projects])

    # in app controller
    load_data_for_charts(records, dates, :projects, :users, 'charts.summary.date', true, @date_formatted)

  end

end
