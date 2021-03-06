class TimestampsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:staff])
  end
  before_filter do |controller_instance|
    controller_instance.send(:is_active_user?)
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
    gon.todays_date = Time.now.to_date.to_s
  end

  def edit
    @timestamp = Timestamp.find(params[:id])
    @preselected_others = @timestamp.children.pluck(:user_id)
    gon.timestamp_date = @timestamp.date.to_s
    gon.todays_date = Time.now.to_date.to_s
  end

  def create
    users = []
    if params[:timestamp][:assignee].present?
      assignee = params[:timestamp][:assignee].delete_if {|r| r.empty? } #delete(:assignee).
      if assignee.index('0')
        users = current_user.others
      else
        users = current_user.others.find(assignee)
      end
    end

    @timestamp = Timestamp.new(params[:timestamp])
    @timestamp.user_id = current_user.id

    respond_to do |format|
      if @timestamp.save
        if users.present?
          Timestamp.transaction do
            users.each {|user|
              Timestamp.create(params[:timestamp].merge({user_id: user.id, parent_id: @timestamp.id }))
            }
          end

          # notifiy users that time was added for them
          message = Message.new
          message.subject = I18n.t("mailer.notification.new_shared_hours.subject")
          message.message = I18n.t("mailer.notification.new_shared_hours.message",
              parent_user: current_user.nickname,
              activity: @timestamp.activity.full_name_with_project,
              date: I18n.l(@timestamp.date),
              duration: @timestamp.duration)
          message.bcc = users.map(&:email)
          NotificationMailer.new_shared_hours(message).deliver

        end
        format.html { redirect_to @redirect_url, notice: t('app.msgs.success_created', :obj => t('activerecord.models.timestamp')) }
      else
        gon.timestamp_date = @timestamp.date.to_s
        gon.todays_date = Time.now.to_date.to_s
        @preselected_others = users.map(&:id)
        format.html { render action: "new" }
      end
    end
  end

  def update
    users = []
    if params[:timestamp][:assignee].present?
      assignee = params[:timestamp].delete(:assignee).delete_if {|r| r.empty? }
      if assignee.index('0')
        users = current_user.others
      else
        users = current_user.others.find(assignee)
      end
    end
    @timestamp = Timestamp.find(params[:id])
    users_ids = users.map{|m| m.id}
    current_users = @timestamp.children.pluck(:user_id).delete_if {|r| users_ids.index(r) }
    respond_to do |format|
      if @timestamp.update_attributes(params[:timestamp])
        Timestamp.transaction do
          if users.present?
            users.each {|user|
              t = Timestamp.where({user_id: user.id, parent_id: @timestamp.id}).first
              pars = params[:timestamp].merge({user_id: user.id, parent_id: @timestamp.id})
              t.present? ? t.update_attributes(pars) : Timestamp.create(pars)
            }
          end
          Timestamp.where({user_id: current_users, parent_id: @timestamp.id}).destroy_all if current_users.present?
        end
        format.html { redirect_to @redirect_url, notice: t('app.msgs.success_updated', :obj => t('activerecord.models.timestamp')) }
      else
        gon.timestamp_date = @timestamp.date.to_s
        gon.todays_date = Time.now.to_date.to_s
        @preselected_others = users.map(&:id)
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    Timestamp.transaction do
      @timestamp = Timestamp.find(params[:id])
      @timestamp.children.destroy_all
      @timestamp.destroy
    end

    respond_to do |format|
      format.html { redirect_to @redirect_url }
    end
  end


  private

  def set_redirect_url
    # breakdown the referer into controller/action
    # this is used so know whether to return to home page or timestamps page
    # referer = Rails.application.routes.recognize_path(request.referrer) if request.referrer.present?
    @redirect_url = request.referrer.present? && request.referrer.index('/timestamps').present? ? timestamps_url : root_url

    # @redirect_url = @referer_controller.present? && @referer_controller == 'timestamps' ? timestamps_url : root_url
  end
end
