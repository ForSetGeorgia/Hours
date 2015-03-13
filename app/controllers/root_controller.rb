class RootController < ApplicationController
	before_filter :authenticate_user!
  before_filter(except: [:index]) do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:staff])
  end

  def index
    if user_signed_in? && current_user.role?(User::ROLES[:staff])
      records = current_user.timestamps.current_day_stamps
      @timestamps = records[:records]

      # for daily chart
      gon.projects = records[:projects]
      gon.dates = records[:dates_formatted]
      gon.bar_chart_title = I18n.t('charts.user.bar.title_today')
      gon.bar_chart_subtitle = I18n.t('charts.user.bar.subtitle_today',
          hours: records[:counts][:hours],
          projects: records[:counts][:projects])
      gon.bar_chart_xaxis = I18n.t('charts.user.bar.xaxis')

      @timestamp = Timestamp.new(stage_id: 4)
      gon.timestamp_date = Time.zone.now.to_date.to_s
    end
  end

end