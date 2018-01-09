class Admin::OrganizationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:site_admin])
  end
  before_filter do |controller_instance|
    controller_instance.send(:is_active_user?)
  end

  def index
    @organizations = Organization.sorted_long_name

    respond_to do |format|
      format.html
    end
  end

  def new
    @organization = Organization.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def create
    @organization = Organization.new(params[:organization])

    respond_to do |format|
      if @organization.save
        format.html { redirect_to admin_organizations_path, notice: t('app.msgs.success_created', :obj => t('activerecord.models.organization')) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to admin_organizations_path, notice: t('app.msgs.success_updated', :obj => t('activerecord.models.organization')) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to admin_organizations_url }
    end
  end
end
