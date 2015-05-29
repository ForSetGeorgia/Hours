class TimestampsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:staff])
  end
  before_filter :set_redirect_url

  def index
    params[:timestamp_start_at] ||= 1.week.ago.in_time_zone.to_date.to_s
    params[:timestamp_end_at] ||= Time.zone.now.to_date.to_s
    records = current_user.timestamps.all_stamps(start_at: params[:timestamp_start_at], end_at: params[:timestamp_end_at])
    dates = current_user.timestamps.dates

    # in app controller
    load_data_for_charts(records, dates, :projects, :dates, 'charts.user')
    
    # if records[:records].present?

    #   @timestamps = records[:records]

    #   # for chart
    #   gon.chart_data = records[:projects]
    #   gon.datepicker_dates = dates
    #   gon.dates = records[:dates_formatted]
    #   gon.bar_chart_title = I18n.t('charts.user.bar.title')
    #   gon.bar_chart_subtitle = I18n.t('charts.user.bar.subtitle',
    #       start: params[:timestamp_start_at], end: params[:timestamp_end_at],
    #       hours: records[:counts][:hours],
    #       projects: records[:counts][:projects],
    #       dates: records[:counts][:dates])
    #   gon.bar_chart_xaxis = I18n.t('charts.user.bar.xaxis')
    #   gon.pie_chart_title = I18n.t('charts.user.pie.title')
    #   gon.pie_chart_subtitle = I18n.t('charts.user.pie.subtitle', 
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
 
  def new
    @timestamp = Timestamp.new(stage_id: 4)
    gon.timestamp_date = Time.zone.now.to_date.to_s
  end

  def edit
    @timestamp = Timestamp.find(params[:id])
    gon.timestamp_date = @timestamp.date.to_s
  end

  def create
    @timestamp = Timestamp.new(params[:timestamp])
    @timestamp.user_id = current_user.id

    respond_to do |format|
      if @timestamp.save
        format.html { redirect_to @redirect_url, notice: t('app.msgs.success_created', :obj => t('activerecord.models.timestamp')) }
      else
        gon.timestamp_date = @timestamp.zone.to_date.to_s
        format.html { render action: "new" }
      end
    end
  end

  def update
    @timestamp = Timestamp.find(params[:id])

    respond_to do |format|
      if @timestamp.update_attributes(params[:timestamp])
        format.html { redirect_to @redirect_url, notice: t('app.msgs.success_updated', :obj => t('activerecord.models.timestamp')) }
      else
        gon.timestamp_date = @timestamp.date.to_s
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @timestamp = Timestamp.find(params[:id])
    @timestamp.destroy

    respond_to do |format|
      format.html { redirect_to @redirect_url }
    end
  end


  private

  def set_redirect_url
    @redirect_url = @referer_controller.present? && @referer_controller == 'timestamps' ? timestamps_url : root_url
  end
end
