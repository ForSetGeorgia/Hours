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
    begin_at = Timestamp.by_user(params[:timestamp_user_id]).start_date
    last_at = Timestamp.by_user(params[:timestamp_user_id]).end_date

    if records[:records].present?

      @timestamps = records[:records]

      # for chart
      gon.projects = records[:projects]
      gon.dates = records[:dates]
      gon.bar_chart_title = I18n.t('charts.summary.user.bar.title', user: @user.nickname)
      gon.bar_chart_subtitle = I18n.t('charts.summary.user.bar.subtitle',
          start: params[:timestamp_start_at], end: params[:timestamp_end_at],
          hours: records[:counts][:hours],
          projects: records[:counts][:projects],
          dates: records[:counts][:dates])
      gon.bar_chart_xaxis = I18n.t('charts.summary.user.bar.xaxis')
      gon.pie_chart_title = I18n.t('charts.summary.user.pie.title', user: @user.nickname)
      gon.pie_chart_subtitle = I18n.t('charts.summary.user.pie.subtitle', 
          start: params[:timestamp_start_at], end: params[:timestamp_end_at],
          hours: records[:counts][:hours],
          projects: records[:counts][:projects],
          dates: records[:counts][:dates])

      # dates for date picker
      gon.begin_at = begin_at.strftime('%m/%d/%Y')
      gon.last_at = last_at.strftime('%m/%d/%Y')
      gon.start_at = params[:timestamp_start_at].to_s
      gon.end_at = params[:timestamp_end_at].to_s
    end
  end

  def project

  end

  def day

  end

end