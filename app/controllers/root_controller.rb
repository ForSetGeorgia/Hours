class RootController < ApplicationController
	before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:staff])
  end

  def index
    if current_user.role?(User::ROLES[:admin])
      @timestamps = Timestamp.stamps_today
    else
      @timestamps = current_user.timestamps.stamps_today
    end
    
    # for daily chart
    projects = Hash.new(0)
    @timestamps.each do |t|
      projects[t.project.name] += t.duration
    end
    gon.projects = []
    projects.each do |k,v|
      gon.projects << {name: k, data: [v.to_f/60]}
    end

    @timestamp = Timestamp.new
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