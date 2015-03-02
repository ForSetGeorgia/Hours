class Admin::ScopesController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:admin])
  end

  # GET /scopes
  # GET /scopes.json
  def index
    @scopes = Scope.sorted

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scopes }
    end
  end

  # GET /scopes/1
  # GET /scopes/1.json
  def show
    @scope = Scope.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @scope }
    end
  end

  # GET /scopes/new
  # GET /scopes/new.json
  def new
    @scope = Scope.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scope }
    end
  end

  # GET /scopes/1/edit
  def edit
    @scope = Scope.find(params[:id])
  end

  # POST /scopes
  # POST /scopes.json
  def create
    @scope = Scope.new(params[:scope])

    respond_to do |format|
      if @scope.save
        format.html { redirect_to admin_scopes_path, notice: t('app.msgs.success_updated', :obj => t('activerecord.models.scope')) }
        format.json { render json: @scope, status: :created, location: @scope }
      else
        format.html { render action: "new" }
        format.json { render json: @scope.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /scopes/1
  # PUT /scopes/1.json
  def update
    @scope = Scope.find(params[:id])

    respond_to do |format|
      if @scope.update_attributes(params[:scope])
        format.html { redirect_to admin_scopes_path, notice: t('app.msgs.success_updated', :obj => t('activerecord.models.scope')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @scope.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scopes/1
  # DELETE /scopes/1.json
  def destroy
    @scope = Scope.find(params[:id])
    @scope.destroy

    respond_to do |format|
      format.html { redirect_to admin_scopes_url }
      format.json { head :no_content }
    end
  end
end
