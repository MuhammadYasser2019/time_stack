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
    @users_on_project = User.all
  end

  # GET /projects/1/edit
  def edit
    @customers = Customer.all
    @project_id = params[:id]
    @project = Project.includes(:tasks).find(params[:id])
    @applicable_week = Week.joins(:time_entries).where("(weeks.status_id = ? or weeks.status_id = ?) and time_entries.project_id= ? and time_entries.status_id=?", "2", "4",params[:id],"2").select(:id, :user_id, :start_date, :end_date , :comments).distinct
    @users_on_project = User.joins("LEFT OUTER JOIN projects_users ON users.id = projects_users.user_id AND projects_users.project_id = #{@project.id}").select("users.email,first_name,email,users.id id,user_id, projects_users.project_id, projects_users.active,project_id")
    @users = User.all
    @invited_users = User.where("invited_by_id = ?", current_user.id)
    @proxies = User.where(proxy: true)
    @customer = Customer.find(@project.customer_id)
    customer_holiday_ids = CustomersHoliday.where(customer_id: @project.customer.id).pluck(:holiday_id)
    @holidays = Holiday.where(global:true).or(Holiday.where(id: customer_holiday_ids))
    @holiday_exception = HolidayException.new
    @holiday_exceptions = @project.holiday_exceptions
  end

  # POST /projects
  # POST /projects.json
  def create
    logger.debug "ID YO #{params[:project][:tasks_attributes].inspect}"
    if params[:project][:tasks_attributes]
      params[:project][:tasks_attributes].each do |t, k|
        logger.debug "T1: #{params[:project][:tasks_attributes][t][:code]}"

        if params[:project][:tasks_attributes][t][:code] == ""
          params[:project][:tasks_attributes].delete t
        end
      end
    end
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
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
    
    task_attributes = params[:project][:tasks_attributes]
    previous_codes = Project.previous_codes(@project)
    task_code = Project.task_value(task_attributes, previous_codes)
    task_attributes.permit!.to_h.each do |t|
      logger.debug "CODE: #{t}"
      logger.debug "id: #{t[1]["id"]}"
      if t[1]["id"].blank?
        logger.debug "ID IS NILLLLLLLL"
        t[1]["id"] = Task.all.count + 1
      end
      if Task.where(id: t[1]["id"]).present?
        @task = Task.find(t[1]["id"]).update(code: t[1]["code"], description: t[1]["description"])
      else
        @task = Task.create(id: t[1]["id"], code: t[1]["code"], description: t[1]["description"], project_id: @project.id)
      end
      # logger.debug("############################ the tasks code in projects CONTROLLER #{task.inspect}")
    end

    logger.debug("############################ the tasks code in projects CONTROLLER #{@task.inspect}")
    logger.debug "PROJECT PARAMS: #{project_params.inspect}"
    pp = project_params.delete("tasks_attributes")
    logger.debug "PROJECT PARAMS AFTER: #{project_params.inspect}"
    logger.debug "PROXY BABY: #{params["proxy"]}"
    respond_to do |format|
      if @project.update(name: project_params["name"], customer_id: project_params["customer_id"], proxy: params["proxy"])
        format.html { redirect_to edit_project_path(@project), notice: 'Project was successfully updated.' }
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
    @project.tasks.destroy_all
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve
    @w = Week.find(params[:week_id])
    @w.time_entries.where(project_id: params[:id]).each do |t|
      t.update(status_id: 3, approved_date: Time.now.strftime('%Y-%m-%d'), approved_by: current_user.id)
    end
    @row_id = params[:row_id]
    @w.approved_date = Time.now.strftime('%Y-%m-%d')
    @w.approved_by = current_user.id
    if @w.time_entries.where.not(hours:nil).count == @w.time_entries.where(status_id: 3).count
      @w.status_id = 3
    end
    @w.save!

    manager = current_user
    ApprovalMailer.mail_to_user(@w, manager).deliver
    respond_to do |format|
      format.html {flash[:notice] = "Approved"}
      format.js
    end

  end

  def show_project_reports
    @project_id = params[:id]
    @p = Project.find(@project_id)
    @users = @p.users
    @user_array = @users.pluck(:id)
    @dates_array = @p.find_dates_to_print(params[:proj_report_start_date], params[:proj_report_end_date])
    if params[:user] == "" || params[:user] == nil
      @consultant_hash = @p.build_consultant_hash(@project_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], @user_array)
    else
      @consultant_hash = @p.build_consultant_hash(@project_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], [params[:user]])
    end

    respond_to do |format|
      format.js
      format.xlsx
      format.html{}
     
    end
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
  
  def permission_denied
    
  end

  def deactivate_project
    @project = Project.find(params[:id])
    @project.update(inactive: 1)
    redirect_to projects_path
  end

  def reactivate_project
    @project = Project.find(params[:id])
    @project.update(inactive: 0)
    redirect_to projects_path
  end

  def make_user_apm
    user = User.find(params[:user_apm])
    user.update(start_apm: params[:start_apm], end_apm: params[:end_apm], project_apm: params[:project_apm])
    redirect_to edit_project_path(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :customer_id, :user_id, :proxy,
      tasks_attributes: [:id, :code, :description, :project_id, :delete])
    end
end
