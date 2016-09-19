class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.where(user_id: current_user.id)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @customers = Customer.all
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @customers = Customer.all
    @project = Project.includes(:tasks).find(params[:id])
    @applicable_week = Week.joins(:time_entries).where("weeks.status_id = ? and time_entries.project_id= ?", "2",params[:id]).select(:id, :user_id, :start_date, :end_date , :comments).distinct
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve
    @w = Week.find(params[:id])
    @w.status_id = 3
    @row_id = params[:row_id]
    @w.approved_date = Time.now.strftime('%Y-%m-%d')
    @w.approved_by = current_user.id
    @w.save!

    manager = current_user
    ApprovalMailer.mail_to_user(@w, manager).deliver
    respond_to do |format|
      format.html {flash[:notice] = "Approved"}
      format.js
    end

  end

  def show_project_reports
    respond_to do |format|
      format.html
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :customer_id)
    end
end
