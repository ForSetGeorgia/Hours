class Admin::ProgramsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:staff])
  end
  def index
    @programs = Program.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @program = Program.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @program = Program.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @program = Program.find(params[:id])
  end

  def create
    @program = Program.new(params[:program])

    respond_to do |format|
      if @program.save
        format.html { redirect_to admin_programs_path, notice: 'Program was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @program = Program.find(params[:id])

    respond_to do |format|
      if @program.update_attributes(params[:program])
        format.html { redirect_to admin_programs_path, notice: 'Program was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @program = Program.find(params[:id])
    @program.destroy

    respond_to do |format|
      format.html { redirect_to admin_programs_url }
    end
  end
end
