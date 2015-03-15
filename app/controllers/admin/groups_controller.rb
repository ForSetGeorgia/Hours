class Admin::GroupsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end

  def index
    @groups = Group.sorted

    respond_to do |format|
      format.html
    end
  end

  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @group = Group.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        format.html { redirect_to admin_groups_path, notice: t('app.msgs.success_created', :obj => t('activerecord.models.group')) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to admin_groups, notice: t('app.msgs.success_updated', :obj => t('activerecord.models.group')) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to admin_groups_url }
    end
  end
end
