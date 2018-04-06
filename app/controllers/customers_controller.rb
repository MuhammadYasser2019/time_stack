 class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /customers
  # GET /customers.json
  def index
    
    @customers = Customer.where(user_id: current_user.id)
    @weeks  = Week.where("user_id = ?", current_user.id).order(start_date: :desc).limit(5)
    if @customers.present?
      params[:customer_id] = @customers.first.id unless params[:customer_id].present?
      @customer = @customers.first
      customer_holiday_ids = CustomersHoliday.where(customer_id: @customer.id).pluck(:holiday_id)
      @projects = @customer.projects
      @pm_projects = Project.where("user_id=?", current_user.id)
      @holidays = Holiday.where(global:true).or(Holiday.where(id: customer_holiday_ids))
      @customer_holiday = CustomersHoliday.new
      @invited_users = User.where("invited_by_id = ?", current_user.id)
      @users = User.where("customer_id IS ? OR customer_id = ?", nil , params[:customer_id])
      @employment_type = EmploymentType.where(customer_id: @customer.id)
      @users_eligible_to_be_manager = User.where("customer_id = ? OR admin = ?",@customer.id, 1)
      logger.debug("customer edit- @users_eligible_to_be_manager #{@users_eligible_to_be_manager.inspect}")
      @user_with_pm_role = User.where("customer_id =? and pm=?", @customer.id, true)
      # @users= User.all
      logger.debug("CUSTOMER EMPLOYEES ARE: #{@users.inspect}")
      @vacation_requests = VacationRequest.where("customer_id= ? and status = ?", params[:customer_id], "Requested")
      @adhoc_projects = Project.where("adhoc_pm_id is not null")
      @vacation_types = VacationType.where("customer_id=? && active=?", @customer.id, true)
      logger.debug("************User requesting VACATION: #{@vacation_requests.inspect} ")
      logger.debug("TRYING TO FIND CUSTOMER LOGGGGGOOOOOOOOOO: #{@customer.logo}")
    end
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
    @adhoc_projects = Project.where("adhoc_pm_id is not null")
    logger.debug("************User requesting VACATION: #{@vacation_requests.inspect} ")
    logger.debug("TRYING TO FIND CUSTOMER LOGGGGGOOOOOOOOOO: #{@customer.logo}")
  end

  # POST /customers
  # POST /customers.json
  def create
    @users_eligible_to_be_manager = User.where("customer_id = ? OR admin = ?",@customer.id, 1)
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
    @customer.user_id = params[:customer][:user_id].present? ? params[:customer][:user_id] : @customer.user_id
    logger.debug("THIS IS THE CUSTOMER UPDATE METHOD")
    params[:customer_id] = @customer.id
    customer_holiday_ids = CustomersHoliday.where(customer_id: @customer.id).pluck(:holiday_id)
    @holidays = Holiday.where(global:true).or(Holiday.where(id: customer_holiday_ids))
    @customer_holiday = CustomersHoliday.new
    @invited_users = User.where("invited_by_id = ?", current_user.id)
    @users = User.where("customer_id IS ? OR customer_id = ?", nil , params[:customer_id])
    
    @employment_type = EmploymentType.where(customer_id: @customer.id)
    @users_eligible_to_be_manager = User.where("customer_id = ? OR admin = ?",@customer.id, 1)
    logger.debug("customer edit- @users_eligible_to_be_manager #{@users_eligible_to_be_manager.inspect}")

    # @users= User.all
    @user_with_pm_role = User.where("customer_id =? and pm=?", @customer.id, true)
    logger.debug("CUSTOMER EMPLOYEES ARE: #{@users.inspect}")
    @vacation_requests = VacationRequest.where("customer_id= ? and status = ?", params[:customer_id], "Requested")
    @adhoc_projects = Project.where("adhoc_pm_id is not null")
    @customer.save
    @vacation_types = VacationType.where("customer_id=? && active=?", @customer.id, true)
    logger.debug("CHECK FOR CUSTOMER params#{@cutomer.inspect}")
    respond_to do |format|
      if @customer.update(customer_params)
    	  @projects = @customer.projects
	      format.js
        format.html { redirect_to customers_path, notice: 'Customer was successfully updated.' }
        format.json { redirect_to "/customers/#{params[:id]}/theme" }
      else
        format.html { render :index }
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
    project = Project.find(params[:project_id])

    @user = User.invite!(email: params[:email], :invitation_start_date => params[:invite_start_date],:employment_type => params[:employment_type], invited_by_id: params[:invited_by_id].to_i, pm: params[:project_manager], shared: params[:shared_user])
    @user.update(invited_by_id: params[:invited_by_id], customer_id: project.customer_id)
    pu = ProjectsUser.new
    # @users_on_project = @project.users
    # @users_on_project = params[:user_id]
    # @project = Project.find(1)

    user = User.find(@user.id)
    
    if project.users.include?(user)
      
    else
      project.users.push(user)
    end
    project.save

    redirect_to customers_path
  end

  def customers_pending_email
    logger.debug "CHECKING FOR params[:user_id]  #{params[:user_id]}"
    @cuser = User.find(params[:user_id])
    user_project = ProjectsUser.find_by_user_id(params[:user_id]).project_id
    @project = Project.find(user_project)
  end

  def remove_user_from_customer
    #customer_id = params[:customer_id]
    user = User.find(params[:user_id])
    @row_id = params[:row]
    #logger.debug("CUSTOMER ID: #{customer_id}***********AND USER CUSTOMER ID: #{user.customer_id}")
    if !user.blank?
      user.customer_id = nil
      user.save
      logger.debug("REMOVING THE USER*******")
      @verb = "Removed" 
    end
    respond_to do |format|
     format.js
   end
  end

  def remove_emp_from_vacation
    #customer_id = params[:customer_id]
    etype = EmploymentTypesVacationType.where("employment_type_id=? && vacation_type_id=?", params[:emp_id], params[:vacation_id]).first
    @row_id = params[:row]
    #logger.debug("CUSTOMER ID: #{customer_id}***********AND USER CUSTOMER ID: #{user.customer_id}")
    if etype
      etype.destroy 
    end
    respond_to do |format|
      format.js
    end
  end

  def shared_user
    @shuser = User.find params[:user_id]
    @customer = Customer.where("id != ?", params[:customer_id])
    #if @shuser.present?
    #  if @shuser.shared?
     #   @shuser.shared = false
     # else
     #   @shuser.shared = true
     # end
     # @shuser.save
    #end
    respond_to do |format|
      format.js
    end
  end

  def add_shared_users
    if params[:user_id].present? && params[:customer_id].present?
      @shuser = User.find params[:user_id]
      sh_emplyee = SharedEmployee.where("user_id =? and customer_id=?", params[:user_id], params[:customer_id]).first
      if sh_emplyee.present?
        sh_emplyee.destroy!
      else
        SharedEmployee.create!(user_id: params[:user_id], customer_id: params[:customer_id], permanent: false)
      end
    end
    respond_to do |format|
      format.js
    end

  end


  def add_pm_role
    user = User.find params[:user_id]
    if user.present?
      if user.pm?
        user.pm = false
      else
        user.pm = true
      end
      user.save
    end
    respond_to do |format|
      format.js
    end
  end

  def assign_proxy_role
    user = User.find params[:user_id]
    if user.present?
      if user.proxy?
        user.proxy = false
      else
        user.proxy = true
      end
      user.save
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
      format.html { redirect_to customers_path}
    end
  end

  def vacation_request
    logger.debug("THE PARAMETERS ARE:  #{params.inspect}")
    @user = current_user
    @users_vacations = VacationRequest.where("user_id = ?",@user.id)
    emp_type = EmploymentType.find current_user.employment_type
    @vacation_types = emp_type.vacation_types.where("customer_id=? && active=?", @user.customer_id, true)
    user_customer = @user.customer_id 
    #sick_leave = params[:vacation_type_id]
    #personal_leave = params[:personal_leave]
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
      new_vr.vacation_type_id = params[:vacation_type_id]
      new_vr.save
    end
    #logger.debug("sick_leave: #{sick_leave}******personal_leave: #{personal_leave} ")
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
    @customer = Customer.find(@customer_id)
    @users = Array.new
    if params[:exclude_pending_users].present?
      @customer.projects.each do |p|
        @users << p.users.where.not(invitation_accepted_at: nil)
      end
    else
      @customer.projects.each do |p|
        @users << p.users
      end
    end
    @users = @users.flatten.uniq
    @users_array = @users.pluck(:id)
    logger.debug("THE USER IDS ARE: #{@users_array}")
    @projects = @customer.projects
    @dates_array = @customer.find_dates_to_print(params[:proj_report_start_date], params[:proj_report_end_date], params["current_week"], params["current_month"])
    @week_array = @customer.find_week_id(params[:proj_report_start_date], params[:proj_report_end_date],@users_array)
    logger.debug("THE WEEK ID YOU ARE LOOKING FOR ARE :  #{@week_array}")
    if params[:user] == "" || params[:user] == nil
      if params[:project] == "" || params[:project] == nil
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], @users_array, @projects, params["current_week"], params["current_month"])
      else
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], @users_array, params[:project], params["current_week"], params["current_month"])
      end
    else
      if params[:project] == "" || params[:project] == nil
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], [params[:user]], @projects, params["current_week"], params["current_month"])
      else
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], [params[:user]], params[:project], params["current_week"], params["current_month"])
      end

    end
  end

  def add_adhoc_pm_by_cm
    @customer = Customer.find(params[:customer_id])
    @project = Project.find(params[:pm_project_id])
    @adhoc_pm = @project.adhoc_pm_id
    @user = User.find(params[:adhoc_pm_id])
    if @adhoc_pm.present? && @adhoc_pm != @user.id
      @project.adhoc_pm_id = nil
      @project.adhoc_start_date = nil
      @project.adhoc_end_date = nil
      @project.save
    end
    @project.adhoc_pm_id = params[:adhoc_pm_id]
    @project.adhoc_start_date = params[:adhoc_start_date]
    @project.adhoc_end_date = params[:adhoc_end_date]
    @project.save
    @adhoc_projects = Project.where("adhoc_pm_id is not null")
    respond_to do |format|
      format.js
    end
  end

  def assign_employment_types

    @customer = Customer.find params[:customer_id]
    @employment_type = EmploymentType.where(customer_id: params[:customer_id])
    @employment_type.each do |e|
      etype_vtype = EmploymentTypesVacationType.where("employment_type_id=? and vacation_type_id=?", e.id, params[:vacation_type_id])
      if etype_vtype.blank? && params["employment_type_#{e.id}"] == "1"
        etype_vtype = EmploymentTypesVacationType.new
        etype_vtype.vacation_type_id = params[:vacation_type_id]
        etype_vtype.employment_type_id = e.id
        etype_vtype.save
      end
    end
    @vacation_types = VacationType.where("customer_id=? && active=?", params[:customer_id], true)
    respond_to do |format|
      format.js
    end
  end

  def assign_pm
    @customer = Customer.find params[:id]
    @user_with_pm_role = User.where("customer_id =? and pm=?", @customer.id, true)
    @projects = @customer.projects

    if params["user_id"].present? && params["project_id"].present?      
      @project = Project.find params["project_id"]
      @project.user_id = params["user_id"].to_i
      @project.save

      @projects = @customer.projects
      respond_to do |format|
        format.js
      end
    end
    
  end

  def available_users
    logger.debug "available_users - starting to process, params passed  are #{params[:id]}"
    project_id  = params[:id]
    project = Project.find params[:id]	
    
    @users = project.users
    logger.debug "available_users - leaving  @users is #{@users}"
    
  end

  def get_employment
    logger.debug "available_emp - starting to process, params passed  are #{params[:vacation_id]}"
    vacation_id  = params[:vacation_id]
    vacation = VacationType.find vacation_id  
    
    @emp = vacation.employment_types
    logger.debug "available_emp - leaving  @emp is #{@emp.inspect}"
  end

  def dynamic_customer_update

    logger.debug("customer-dynamic_customer_update- CUSTOMER ID IS #{params.inspect}")
    @customer = Customer.find params[:customer_id]
    customer_holiday_ids = CustomersHoliday.where(customer_id: @customer.id).pluck(:holiday_id)
	
    @holidays = Holiday.where(global:true).or(Holiday.where(id: customer_holiday_ids))
    @customer_holiday = CustomersHoliday.new
    @projects = @customer.projects
    @invited_users = User.where("invited_by_id = ?", current_user.id)
    @users = User.where("customer_id IS ? OR customer_id = ?", nil , params[:customer_id])
    @employment_type = EmploymentType.where(customer_id: @customer.id)
    @users_eligible_to_be_manager = User.where("customer_id = ? OR admin = ?",@customer.id, 1)
    logger.debug("customer-dynamic-update- @users_eligible_to_be_manager #{@users_eligible_to_be_manager.inspect}")
    @user_with_pm_role = User.where("customer_id =? and pm=?", @customer.id, true)
    # @users= User.all
    logger.debug("CUSTOMER EMPLOYEES ARE: #{@users.inspect}")
    @vacation_requests = VacationRequest.where("customer_id= ? and status = ?", params[:customer_id], "Requested")
    @adhoc_projects = Project.where("adhoc_pm_id is not null")
    @vacation_types = VacationType.where("customer_id=? && active=?", @customer.id, true)
    logger.debug("************User requesting VACATION: #{@vacation_requests.inspect} ")
    logger.debug("TRYING TO FIND CUSTOMER LOGGGGGOOOOOOOOOO: #{@customer.logo}")
	
    respond_to do |format|  
      format.js
    end
  end

  def questionaire

    email = params[:anything][:email]
    type = params[:anything][:feedback]
    notes = params[:anything][:notes]
    # image = params[:anything][:attachment]
    FeedbackMailer.question_email(email,type,notes).deliver
      respond_to do |format|
         format.html { redirect_to "/", notice: 'Vacation request sent successfully.' }
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
