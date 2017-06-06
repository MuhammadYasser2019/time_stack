class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.where(user_id: current_user.id)
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    @users_eligible_to_be_manager = User.where("admin = ?", 1)
  end

  # GET /customers/1/edit
  def edit
    customer_holiday_ids = CustomersHoliday.where(customer_id: @customer.id).pluck(:holiday_id)
    @projects = @customer.projects
    @holidays = Holiday.where(global:true).or(Holiday.where(id: customer_holiday_ids))
    @customer_holiday = CustomersHoliday.new
    @invited_users = User.where("invited_by_id = ?", current_user.id)
    @users = User.where("customer_id IS ? OR customer_id = ?", nil , params[:id])
    @employment_type = EmploymentType.where(customer_id: @customer.id)
    @users_eligible_to_be_manager = User.where("customer_id = ? OR admin = ?",@customer.id, 1)
    logger.debug("customer edit- @users_eligible_to_be_manager #{@users_eligible_to_be_manager.inspect}")

    # @users= User.all
    logger.debug("CUSTOMER EMPLOYEES ARE: #{@users.inspect}")
    @vacation_requests = VacationRequest.where("customer_id= ? and status = ?", params[:id], "Requested")
    logger.debug("************User requesting VACATION: #{@vacation_requests.inspect} ")
    logger.debug("TRYING TO FIND CUSTOMER LOGGGGGOOOOOOOOOO: #{@customer.logo}")
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)
    @customer.user_id = current_user.id
    @customer.theme = "Orange" 
    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_path, notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    if params[:customer].blank?
      params[:customer] =params
    end
    @customer.user_id = params[:customer][:user_id]
    logger.debug("THIS IS THE CUSTOMER UPDATE METHOD")
    @customer.save
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to edit_customer_path(@customer), notice: 'Customer was successfully updated.' }
        format.json { redirect_to "/customers/#{params[:id]}/theme" }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def report
    logger "report - params passed are  project_id: #{params[:project_id]},  start_date: #{params[:start_date]}, end_date: #{params[:end_date]}"
    if !params[:project_id].nil?
      logger.debug "report - now  running a report for project  #{params[:project_id]}"
      
    end 
  end
  
  def invite_to_project
    logger.debug "INVITED BY #{params[:invited_by_id]}"
    @user = User.invite!(email: params[:email], invited_by_id: params[:invited_by_id].to_i, pm: params[:project_manager])
    @user.update(invited_by_id: params[:invited_by_id])
    pu = ProjectsUser.new
    # @users_on_project = @project.users
    # @users_on_project = params[:user_id]
    # @project = Project.find(1)

    user = User.find(@user.id)
    project = Project.find(params[:project_id])
    if project.users.include?(user)
      
    else
      project.users.push(user)
    end
    project.save

    redirect_to edit_customer_path(params[:customer_id])
  end

  def remove_user_from_customer
    customer_id = params[:customer_id]
    user = User.find(params[:user_id])
    logger.debug("CUSTOMER ID: #{customer_id}***********AND USER CUSTOMER ID: #{user.customer_id}")
    if !customer_id.blank? && !user.blank?
      user.customer_id = nil
      user.save
      logger.debug("REMOVING THE USER*******")
      @verb = "Removed" 
    end
    respond_to do |format|
     format.js
   end
  end

  def edit_customer_user
    logger.debug("customer_controller- edit_customer_user ")
    @user = User.find(params[:user_id])
    user_customer_id = @user.customer_id
    @employment_types = EmploymentType.where(customer_id: user_customer_id )
    respond_to do |format|
      format.html
    end
  end

  def update_user_employment
    logger.debug("customer.controller - update_user_employment ")
    user = User.find(params[:user_id])
    user.employment_type = params[:employment_type]
    user.save
    respond_to do |format|
      format.html { redirect_to "/customers/#{user.customer_id}/edit"}
    end
  end

  def vacation_request
    logger.debug("THE PARAMETERS ARE:  #{params.inspect}")
    @user = current_user
    @users_vacations = VacationRequest.where("user_id = ?",@user.id)
    user_customer = @user.customer_id 
    sick_leave = params[:sick_leave]
    personal_leave = params[:personal_leave]
    vacation_start_date = params[:vacation_start_date]
    vacetion_end_date = params[:vacation_end_date]
    reason_for_vacation = params[:vacation_comment]
    if !vacation_start_date.blank?
      new_vr = VacationRequest.new
      new_vr.vacation_start_date = params[:vacation_start_date]
      new_vr.vacation_end_date = params[:vacation_end_date]
      new_vr.user_id = @user.id
      new_vr.customer_id = @user.customer_id
      new_vr.comment = reason_for_vacation
      new_vr.status = "Requested"
    
      if !sick_leave.blank?
        new_vr.sick = true
      end
      if !personal_leave.blank?
        new_vr.personal = true
      end
      new_vr.save
    end
    logger.debug("sick_leave: #{sick_leave}******personal_leave: #{personal_leave} ")
    customer_manager = Customer.find(user_customer).user_id
    logger.debug("customer manager id IS : #{customer_manager}")

    if !vacation_start_date.blank?
      VacationMailer.mail_to_customer_owner(@user, customer_manager,vacation_start_date,vacetion_end_date ).deliver
      respond_to do |format|
        format.html { redirect_to "/", notice: 'Vacation request sent successfully.' }
      end
    end
  end

  def resend_vacation_request
    logger.debug("RESEND VACATION REQUEST PARAMS: #{params.inspect}")
    user = current_user
    vacation_request = VacationRequest.find(params[:vacation_request_id])
    user_customer = user.customer_id
    customer_manager = Customer.find(user_customer).user_id
    modified_vacation_start_date = params[:vacation_start]
    modified_vacation_end_date = params[:vacation_end]
    vacation_request.vacation_start_date = modified_vacation_start_date
    vacation_request.vacation_end_date = modified_vacation_end_date
    vacation_request.status = "Requested"
    vacation_request.save
    
    # VacationMailer.mail_to_customer_owner(user, customer_manager,modified_vacation_start_date,modified_vacation_end_date ).deliver
    respond_to do |format|
      format.js
    end
  end

  def approve_vacation
    @vr = params[:vr_id]
    logger.debug("888888888888888888 : #{@vr.inspect}")
    @row_id = params[:row_id]
    customer_manager = current_user
    vacation_request = VacationRequest.find(@vr)
    vacation_request.status = "Approved"
    vacation_request.save
    VacationMailer.mail_to_vacation_requestor(@vr, customer_manager ).deliver
    # @user.vacation_start_date = "NULL"
    # @user.vacation_end_date = "NULL"
    # @user.save
    # @dates_array = @user.find_dates_to_print(params[:vacation_start_date], params[:vacation_end_date])

     

    respond_to do |format|
      format.html {flash[:notice] = "Approved"}
      format.js
    end
  end

  def reject_vacation
    @vr = params[:vr_id]
    logger.debug("888888888888888888 : #{@vr.inspect}")
    @row_id = params[:row_id]
    customer_manager = current_user
    vacation_request = VacationRequest.find(@vr)
    vacation_request.status = "Rejected"
    vacation_request.save
    VacationMailer.rejection_mail_to_vacation_requestor(@vr, customer_manager ).deliver
    # @user.vacation_start_date = "NULL"
    # @user.vacation_end_date = "NULL"
    # @user.save
    respond_to do |format|
      format.html {flash[:notice] = "Rejected"}
      format.js
    end
  end

  def set_theme
    logger.debug("PARAMETERS FOR THEMES ARE: #{params.inspect}")
    user = current_user
    @customer= Customer.find(params[:id])
    logger.debug("THIS IS THE THEME: #{@customer.theme}") 
    theme_selected = params[:theme]
    if !theme_selected.blank?
      @customer.theme = theme_selected
      @customer.save
    end
    @customer_theme = @customer.theme

  end

  def customer_reports
    @customer_id = params[:id]
    c = Customer.find(@customer_id)
    @users = Array.new
    c.projects.each do |p|
      @users << p.users
    end
    @users = @users.flatten.uniq
    @users_array = @users.pluck(:id)
    @projects = c.projects
    @dates_array = c.find_dates_to_print(params[:proj_report_start_date], params[:proj_report_end_date])
    if params[:user] == "" || params[:user] == nil
      if params[:project] == "" || params[:project] == nil
        @consultant_hash = c.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], @users_array, @projects)
      else
        @consultant_hash = c.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], @users_array, params[:project])
      end
    else
      if params[:project] == "" || params[:project] == nil
        @consultant_hash = c.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], [params[:user]], @projects)
      else
        @consultant_hash = c.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], [params[:user]], params[:project])
      end

    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :address, :city, :state, :zipcode, :logo, holiday_ids: [])
    end
end
