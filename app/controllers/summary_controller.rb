class SummaryController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
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

    records = Timestamp.by_user(params[:timestamp_user_id]).all_stamps(start_at: params[:timestamp_start_at], end_at: params[:timestamp_end_at])
    dates = Timestamp.by_user(params[:timestamp_user_id]).dates
    
    # in app controller
    load_data_for_charts(records, dates, :projects, 'charts.summary.user', true, @user.nickname)

    # if records[:records].present?

    #   if dates.present?
    #     begin_at = dates.first
    #     last_at = dates.last
    #   end

    #   @timestamps = records[:records]

    #   # for chart
    #   gon.chart_data = records[:projects]
    #   gon.datepicker_dates = dates
    #   gon.dates = records[:dates_formatted]
    #   gon.bar_chart_title = I18n.t('charts.summary.user.bar.title', user: @user.nickname)
    #   gon.bar_chart_subtitle = I18n.t('charts.summary.user.bar.subtitle',
    #       start: params[:timestamp_start_at], end: params[:timestamp_end_at],
    #       hours: records[:counts][:hours],
    #       projects: records[:counts][:projects],
    #       dates: records[:counts][:dates])
    #   gon.bar_chart_xaxis = I18n.t('charts.summary.user.bar.xaxis')
    #   gon.pie_chart_title = I18n.t('charts.summary.user.pie.title', user: @user.nickname)
    #   gon.pie_chart_subtitle = I18n.t('charts.summary.user.pie.subtitle', 
    #       start: params[:timestamp_start_at], end: params[:timestamp_end_at],
    #       hours: records[:counts][:hours],
    #       projects: records[:counts][:projects],
    #       dates: records[:counts][:dates])

    #   # dates for date picker
    #   gon.begin_at = begin_at
    #   gon.last_at = last_at
    #   gon.start_at = params[:timestamp_start_at].to_s
    #   gon.end_at = params[:timestamp_end_at].to_s
    # end
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

    records = Timestamp.by_project(params[:timestamp_project_id]).all_stamps(start_at: params[:timestamp_start_at], end_at: params[:timestamp_end_at], type: Timestamp::SUMMARY[:project])
    dates = Timestamp.by_project(params[:timestamp_project_id]).dates
    
    # in app controller
    load_data_for_charts(records, dates, :users, 'charts.summary.project', true, @project.full_name)

    # if records[:records].present?

    #   if dates.present?
    #     begin_at = dates.first
    #     last_at = dates.last
    #   end

    #   @timestamps = records[:records]

    #   # for chart
    #   gon.chart_data = records[:users]
    #   gon.datepicker_dates = dates
    #   gon.dates = records[:dates_formatted]
    #   gon.bar_chart_title = I18n.t('charts.summary.project.bar.title', project: @project.full_name)
    #   gon.bar_chart_subtitle = I18n.t('charts.summary.project.bar.subtitle',
    #       start: params[:timestamp_start_at], end: params[:timestamp_end_at],
    #       hours: records[:counts][:hours],
    #       users: records[:counts][:users],
    #       dates: records[:counts][:dates])
    #   gon.bar_chart_xaxis = I18n.t('charts.summary.project.bar.xaxis')
    #   gon.pie_chart_title = I18n.t('charts.summary.project.pie.title', project: @project.full_name)
    #   gon.pie_chart_subtitle = I18n.t('charts.summary.project.pie.subtitle', 
    #       start: params[:timestamp_start_at], end: params[:timestamp_end_at],
    #       hours: records[:counts][:hours],
    #       users: records[:counts][:users],
    #       dates: records[:counts][:dates])

    #   # dates for date picker
    #   gon.begin_at = begin_at
    #   gon.last_at = last_at
    #   gon.start_at = params[:timestamp_start_at].to_s
    #   gon.end_at = params[:timestamp_end_at].to_s
    # end
  end

  def day

  end

end