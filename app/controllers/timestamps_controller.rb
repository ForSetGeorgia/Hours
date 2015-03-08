class TimestampsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:staff])
  end

  def index
    records = nil
    begin_at = nil
    last_at = nil
    params[:timestamp_start_at] ||= 1.week.ago.in_time_zone.to_date.to_s
    params[:timestamp_end_at] ||= Time.zone.now.to_date.to_s

    if current_user.role?(User::ROLES[:admin]) && (params[:everyone].present? && params[:everyone].to_bool == true)
      records = Timestamp.all_stamps(start_at: params[:timestamp_start_at], end_at: params[:timestamp_end_at])
      begin_at = Timestamp.start_date
      last_at = Timestamp.end_date
    else
      records = current_user.timestamps.all_stamps(start_at: params[:timestamp_start_at], end_at: params[:timestamp_end_at])
      begin_at = current_user.timestamps.start_date
      last_at = current_user.timestamps.end_date
    end

    @timestamps = records[:records]

    # for chart
    gon.projects = records[:projects]
    gon.dates = records[:dates]

    # dates for date picker
    gon.begin_at = begin_at.strftime('%m/%d/%Y')
    gon.last_at = last_at.strftime('%m/%d/%Y')
    gon.start_at = params[:timestamp_start_at].to_s
    gon.end_at = params[:timestamp_end_at].to_s
  end
 
  def new
    @timestamp = Timestamp.new
  end

  def edit
    @timestamp = Timestamp.find(params[:id])
  end

  def create
    @timestamp = Timestamp.new(params[:timestamp])
    @timestamp.user_id = current_user.id

    respond_to do |format|
      if @timestamp.save
        format.html { redirect_to root_url, notice: t('app.msgs.success_created', :obj => t('activerecord.models.timestamp')) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @timestamp = Timestamp.find(params[:id])

    respond_to do |format|
      if @timestamp.update_attributes(params[:timestamp])
        format.html { redirect_to timestamps_url, notice: t('app.msgs.success_updated', :obj => t('activerecord.models.timestamp')) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @timestamp = Timestamp.find(params[:id])
    @timestamp.destroy

    respond_to do |format|
      format.html { redirect_to timestamps_url }
    end
  end
end
