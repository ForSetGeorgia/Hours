class TimestampsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:staff])
  end

  def index
    if current_user.role?(User::ROLES[:admin]) && (params[:everyone].present? && params[:everyone].to_bool == true)
      records = Timestamp.all_stamps
    else
      records = current_user.timestamps.all_stamps
    end

    @timestamps = records[:records]

    # for chart
    gon.projects = records[:projects]
    gon.dates = records[:dates]
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
