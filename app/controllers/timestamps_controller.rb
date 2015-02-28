class TimestampsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end

  # GET /timestamps
  # GET /timestamps.json
  def index
    @timestamps = Timestamp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @timestamps }
    end
  end

  # GET /timestamps/1
  # GET /timestamps/1.json
  def show
    @timestamp = Timestamp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @timestamp }
    end
  end

  # GET /timestamps/new
  # GET /timestamps/new.json
  def new
    @timestamp = Timestamp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @timestamp }
    end
  end

  # GET /timestamps/1/edit
  def edit
    @timestamp = Timestamp.find(params[:id])

  end

  # POST /timestamps
  # POST /timestamps.json
  def create
    @timestamp = Timestamp.new(params[:timestamp])
    @timestamp.user_id = current_user.id

    respond_to do |format|
      if @timestamp.save
        format.html { redirect_to @timestamp, notice: 'Timestamp was successfully created.' }
        format.json { render json: @timestamp, status: :created, location: @timestamp }
      else
        format.html { render action: "new" }
        format.json { render json: @timestamp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /timestamps/1
  # PUT /timestamps/1.json
  def update
    @timestamp = Timestamp.find(params[:id])

    respond_to do |format|
      if @timestamp.update_attributes(params[:timestamp])
        format.html { redirect_to @timestamp, notice: 'Timestamp was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @timestamp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timestamps/1
  # DELETE /timestamps/1.json
  def destroy
    @timestamp = Timestamp.find(params[:id])
    @timestamp.destroy

    respond_to do |format|
      format.html { redirect_to timestamps_url }
      format.json { head :no_content }
    end
  end
end
