class Admin::ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:site_admin])
  end

  def index
    @projects = Project.sorted

    respond_to do |format|
      format.html
    end
  end

  def new
    @project = Project.new

    respond_to do |format|
      format.html
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to admin_projects_path, notice: t('app.msgs.success_created', :obj => t('activerecord.models.project')) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to admin_projects_path, notice: t('app.msgs.success_updated', :obj => t('activerecord.models.project')) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to admin_projects_url }
    end
  end

  def migrate
    @errors = nil
    if request.post?
      if params[:from_activity_id] == params[:to_activity_id]
        @errors = I18n.t('app.msgs.cannot_merge_same')
      else
        # move all timestamps to new activity
        count = Timestamp.where(activity_id: params[:from_activity_id]).update_all(activity_id: params[:to_activity_id])

        if params[:delete_from_activity] == "1"
          Activity.where(id: params[:from_activity_id]).destroy_all
        end

        flash[:notice] = I18n.t('app.msgs.success_merge', count: count)
      end
    end

  end

end
