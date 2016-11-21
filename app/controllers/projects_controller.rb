class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.where(user_id: current_user.id)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @customers = Customer.all
    @project_id = params[:id]
    @project = Project.includes(:tasks).find(params[:id])
  end

  # GET /projects/new
  def new
    @customers = Customer.all
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @customers = Customer.all
    @project_id = params[:id]
    @project = Project.includes(:tasks).find(params[:id])
    @applicable_week = Week.joins(:time_entries).where("weeks.status_id = ? and time_entries.project_id= ?", "2",params[:id]).select(:id, :user_id, :start_date, :end_date , :comments).distinct
    @users_on_project = User.joins("LEFT OUTER JOIN projects_users ON users.id = projects_users.user_id AND projects_users.project_id = #{@project.id}").select("users.email,first_name,email,users.id id,user_id, projects_users.project_id, projects_users.active,project_id")
    @users = User.all
    @invited_users = User.where("invited_by_id = ?", current_user.id)

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
    @customers = Customer.all
    @project_id = params[:id]
    @project = Project.includes(:tasks).find(params[:id])
    @applicable_week = Week.joins(:time_entries).where("weeks.status_id = ? and time_entries.project_id= ?", "2",params[:id]).select(:id, :user_id, :start_date, :end_date , :comments).distinct
    @users_on_project = User.joins("LEFT OUTER JOIN projects_users ON users.id = projects_users.user_id AND projects_users.project_id = #{@project.id}").select("users.email,first_name,email,users.id id,user_id, projects_users.project_id, projects_users.active,project_id")
    @users = User.all
    @invited_users = User.where("invited_by_id = ?", current_user.id)

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

  def self.show_project_reports


  end

  def show_hours
    @user_id = params[:user_id]
    @project_id = params[:project_id]
    @week_id = params[:week_id]

    @applicable_hours = TimeEntry.where("week_id= ? and project_id= ?", @week_id ,@project_id)

  end


  def add_user_to_project
    # User.joins("LEFT OUTER JOIN projects_users ON users.id = projects_users.user_id").select("users.email, projects_users.project_id, projects_users.active").collect {|u| "#{u.email}, #{u.project_id}, Status #{u.active}"}
    logger.debug(" add_user_to_project - #{params.inspect}")

    pu = ProjectsUser.new
    # @users_on_project = @project.users
    # @users_on_project = params[:user_id]
    # @project = Project.find(1)

    user = User.find(params[:user_id])
    project = Project.find(params[:project_id])
    if project.users.include?(user)
      project.users.delete(user)
    else
      project.users.push(user)
    end
    project.save

    respond_to do |format|
     format.js
   end
  end

  def user_time_report
    @user = User.find(params[:user_id])
    logger.debug("user_time_report######## #{params.inspect}")

    @weeks  = Week.where("user_id = ?", @user.id).order(start_date: :desc).limit(10)



  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :customer_id, :user_id, 
      tasks_attributes: [:code, :description ])
    end
end
