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
      gon.dates = records[:dates]

      @timestamp = Timestamp.new
    end
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
        format.html { redirect_to root_url, notice: 'Timestamp was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @timestamp = Timestamp.find(params[:id])

    respond_to do |format|
      if @timestamp.update_attributes(params[:timestamp])
        format.html { redirect_to timestamps_url, notice: 'Timestamp was successfully updated.' }
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