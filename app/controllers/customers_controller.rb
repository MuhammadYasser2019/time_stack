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
      @users = User.where("parent_user_id IS ? && (customer_id IS ? OR customer_id = ?)", nil, nil , params[:customer_id])
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
    @users = User.where("parent_user_id IS ? && (customer_id IS ? OR customer_id = ?)", nil, nil , params[:id])
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
    @users = User.where("parent_user_id IS ? && (customer_id IS ? OR customer_id = ?)", nil, nil , params[:customer_id])
    
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
    project_id = params[:project_id]
    @user = User.invite!(email: params[:email], :invitation_start_date => params[:invite_start_date],:employment_type => params[:employment_type], invited_by_id: params[:invited_by_id].to_i, pm: params[:project_manager], default_project: project_id, shared: params[:shared_user])
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
    user.is_active = params[:is_active].present? ? params[:is_active] : false 
    user.save
    respond_to do |format|
      format.html { redirect_to customers_path}
    end
  end

  def cancel_vacation_request
    #change the value for this vacation_id
    vr = VacationRequest.find(params[:vacation_id])
      vr.status = "CancelRequest"
    vr.save

    logger.debug("This is the vacation #{vr}")
    #Change the ID
    @row_id = params[:vacation_id]
    respond_to do |format|
      format.js 
    end
  end 

  def pre_vacation_request 

      logger.debug("Am i holding v_id#{params[:vacation_type_id]}") 
        start_date = params[:start_date]
        end_date = params[:end_date]
        logger.debug("checking #{end_date.to_date.on_weekend?}")
        num_of_days = (end_date.to_date - start_date.to_date).to_i

          #Now Holidays 
          customer_holidays = CustomersHoliday.where(:customer_id => current_user.customer_id)
          
          holiday_array = []
          customer_holidays.each do |x|
            h_date = Holiday.find(x.holiday_id)
            holiday_array.push(h_date.date.to_date)
          end
          logger.debug(" HOLIDAY DATES #{holiday_array}")

          # CURRENT SOLUTION TO CHECK IF IT IS A HOLIDAY
          start_year_array = []
          end_year_array = []
          holiday_array.each do |correct|
            #correct_year = correct.to_date + 365
            #logger.debug(" before #{correct} and after #{correct_year}")
            #current_year = Date.today.strftime('%Y')
            #plus_year = current_year.to_i
            #proper_year = plus_year.to_s + '-' + correct.to_s.split('-')[1] + '-' + correct.to_s.split('-')[2]

            requested_start_year  = start_date.to_s.split('-')[0]
            year_start = requested_start_year.to_s + '-' + correct.to_s.split('-')[1] + '-' + correct.to_s.split('-')[2]
            start_year_array.push(year_start.to_date)

            requested_end_year = end_date.to_s.split('-')[0] 
            year_end = requested_end_year.to_s + '-' + correct.to_s.split('-')[1] + '-' + correct.to_s.split('-')[2]
            end_year_array.push(year_end.to_date)
          end 
            logger.debug("Start year Array is #{start_year_array}")
            logger.debug("End year array is #{end_year_array}")
            
          a_range = (start_date.to_date .. end_date.to_date)
          weekend_counter = 0
          a_range.each do |date|
            if date.on_weekend? == true
              weekend_counter = weekend_counter + 1
            end 
          end

          start_year_array.each do |ww|
            b = a_range.cover?(ww.to_date)
            if b == true
              weekend_counter = weekend_counter + 1
            end 
            logger.debug(" #{ww.to_date} is a holiday #{b}")
          end 

          end_year_array.each do |ww|
            b = a_range.cover?(ww.to_date)
            if b == true
              weekend_counter = weekend_counter + 1
            end 
            logger.debug(" #{ww.to_date} is a holiday #{b}")
          end 


          ### Holiday Check (use if holiday.dates year updates)
         #logger.debug("Wekend Count #{weekend_counter}")
         #holiday_array.each do |ww|
         #  b = a_range.cover?(ww.to_date)
         #  if b == true
         #    weekend_counter = weekend_counter + 1
         #  end 
         #  logger.debug(" #{ww.to_date} is a holiday #{b}")
         #end 
          logger.debug("Wekend Count + holiday #{weekend_counter}")
          ####


      ###
      @user = current_user
      @vacation_type = VacationType.find(params[:vacation_type_id])
        logger.debug("Accrual: #{@vacation_type.accrual}")
        logger.debug("V-Id: #{@vacation_type.id}")

      uvt = VacationRequest.where("vacation_type_id=? and user_id=?",params[:vacation_type_id], @user.id )
      

       customer = Customer.find(@user.customer_id)
       full_work_day = customer.regular_hours.present? ? customer.regular_hours : 8
       hours_over_month = (full_work_day.to_f/12).to_f

      logger.debug("FULL WORK DAY IS #{full_work_day}") 
      logger.debug("uvt is #{uvt}")
      correct_days = num_of_days - weekend_counter
      hours_requested = correct_days * full_work_day
      logger.debug("Hours Requested #{hours_requested}")

    #HOURS_ALLOWED
      if (@vacation_type.accrual == true && uvt.length > 0 )
            logger.debug(" A = TRUE && UVT != 0")
          #Total Days Used Logic
            total_used = []
            uvt.each do |x|
              if x.hours_used != nil
                total_used.push(x.hours_used)
              else 
                  total_used.push(0)
              end 
            end
            logger.debug("Total Hours Used #{total_used}")
            total_hours_used = total_used.inject :+  #Important

            #Accural Logic(!First) 
                months_at_job = (Date.today.strftime('%m').to_f) - (@user.invitation_start_date.strftime('%m').to_f)
                #Logic for calculating with a new year
                   year = (Date.today.strftime('%Y').to_f) - (@user.invitation_start_date.strftime('%Y').to_f)
                    logger.debug("year calculation is #{year}")
                  if @vacation_type.rollover == true
                    year = year * 12 #conversion to months
                    months_at_job = year + months_at_job
                  else 
                       if year == 0 
                           months_at_job = (Date.today.strftime('%m').to_f) - (@user.invitation_start_date.strftime('%m').to_f)
                       else 
                         months_at_job = Date.today.strftime('%m').to_f
                       end 
                  end 
                  logger.debug("After RollOver Logic, what is the months_at_job #{months_at_job}")
                # end rollover logic
                hour_rate = @vacation_type.vacation_bank.to_f * hours_over_month
              current_hours_allowed = hour_rate * months_at_job #This changes***

              logger.debug("current days allowed #{current_hours_allowed} Total hours Used #{total_hours_used}")

              hours_allowed = current_hours_allowed - total_hours_used 
              logger.debug("Hours allowed #{hours_allowed}")

      elsif (@vacation_type.accrual == true && uvt.length <= 0)
          logger.debug(" A = TRUE && UVT is 0")
          
          #Accural Logic(First) 
                #Logic for calculating with a new year
                year = (Date.today.strftime('%Y').to_f) - (@user.invitation_start_date.strftime('%Y').to_f)
                months_at_job = (Date.today.strftime('%m').to_f) - (@user.invitation_start_date.strftime('%m').to_f)
                logger.debug("year calculation is #{year}")
                if @vacation_type.rollover == true
                  year = year * 12 #conversion to months
                  months_at_job = year + months_at_job
                else 
                     if year == 0 
                         months_at_job = (Date.today.strftime('%m').to_f) - (@user.invitation_start_date.strftime('%m').to_f)
                     else 
                       months_at_job = Date.today.strftime('%m').to_f
                     end 
                end 
                # end rollover logic
          hour_rate = @vacation_type.vacation_bank.to_f * hours_over_month
          hours_allowed = hour_rate * months_at_job  

      elsif (@vacation_type.accrual == false && uvt.length > 0)
          logger.debug(" A == FALSE && UVT != 0")
              total_used = []
              uvt.each do |x|
                if x.hours_used != nil
                  total_used.push(x.hours_used)
                else 
                    total_used.push(0)
                end 
              end
              total_hours_used = total_used.inject :+
              #logic for Rollover
              year = (Date.today.strftime('%Y').to_f) - (@user.invitation_start_date.strftime('%Y').to_f)
              logger.debug("today #{(Date.today.strftime('%Y').to_f)}")
              logger.debug("start date #{(@user.invitation_start_date.strftime('%Y').to_f)}")
              year = year + 1
              vb  = @vacation_type.vacation_bank * full_work_day #converts days to hours
                if @vacation_type.rollover == true
                  logger.debug("nvb is #{vb} x #{year}")
                  nvb = vb * year 
                else 
                  nvb = vb
                end
            hours_allowed = nvb.to_f - total_hours_used
            logger.debug(" VB Hours #{nvb} and total_hours_used is #{total_hours_used}")
      elsif (@vacation_type.accrual == false && uvt.length <= 0)
        logger.debug(" A = FALSE && UVT = 0")
          year = (Date.today.strftime('%Y').to_f) - (@user.invitation_start_date.strftime('%Y').to_f)
          year = year + 1
          vb  = @vacation_type.vacation_bank * full_work_day
            if @vacation_type.rollover == true
              nvb = vb * year
              else 
             nvb = vb
                         end
          hours_allowed = nvb.to_f - total_hours_used
              hours_allowed = nvb
      else
          logger.debug("$$$$$$$$   something went WRONGGGGGGG !!!!!!!")
      end #End Hours Allowed

      logger.debug("THE MATH...vb allows #{@vacation_type.vacation_bank * full_work_day} hours  & hours requested #{hours_requested}")
      logger.debug("THE MATH The hourly rate is #{@vacation_type.vacation_bank}day times 8 hr/day divided by 12months so #{hour_rate} hr/m")
      logger.debug("THE MATH -Accural-...time at job #{months_at_job} months times& hour rate #{hour_rate} is current hours allowed #{current_hours_allowed}")
      logger.debug("THE MATH- Accural - ... total hours used for this vacation type is #{total_hours_used}")
      logger.debug("THE MATH...Pass if hours allowed #{hours_allowed} is greater than hours requested #{hours_requested}")


          if hours_requested.to_f > hours_allowed.to_f 
            logger.debug("NO NOT TODAY!")
              respond_to do |format|
                format.js
                @comment = "Sorry, you only have #{hours_allowed} hours avaliable, but requested #{hours_requested} hours"
              end 
          else
              logger.debug("Success, this should showwww")
                respond_to do |format|
                  format.js{ render :template => "customers/pre_vacation_request_approve.js.erb" }
                end 
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
    customer = Customer.find(@user.customer_id)
    full_work_day = customer.regular_hours.present? ? customer.regular_hours : 8

    if !vacation_start_date.blank?
      days_requested = (params[:vacation_end_date].to_date - params[:vacation_start_date].to_date).to_i
      logger.debug("test #{days_requested}")
      hours_requested = days_requested * full_work_day

     new_vr = VacationRequest.new
     new_vr.vacation_start_date = params[:vacation_start_date]
     new_vr.vacation_end_date = params[:vacation_end_date]
     new_vr.user_id = @user.id
     new_vr.customer_id = @user.customer_id
     new_vr.comment = reason_for_vacation
     new_vr.status = "Requested"
     new_vr.vacation_type_id = params[:vacation_type_id]
     new_vr.hours_used = hours_requested
     new_vr.save
    end

    #logger.debug("sick_leave: #{sick_leave}******personal_leave: #{personal_leave} ")
    customer_manager = Customer.find(user_customer).user_id
    logger.debug("customer manager id IS : #{customer_manager}")

    #if !vacation_start_date.blank?
    #  VacationMailer.mail_to_customer_owner(@user, customer_manager,vacation_start_date,vacetion_end_date ).deliver
    #  respond_to do |format|
    #    format.html { redirect_to "/", notice: 'Vacation request sent successfully.' }
    #  end
    #end
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

  def approve_cancel_request
    #Create A Mailer
    @vr = params[:vr_id]
    logger.debug("888888888888888888 : #{@vr.inspect}")
    @row_id = params[:row_id]
    customer_manager = current_user
    vacation_request = VacationRequest.find(@vr)
    vacation_request.destroy

    respond_to do |format|
      format.html {flash[:notice] = "Cancellation has been approved"}
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
    # @customer.projects.each do |ids|
    #   t = Task.find_by_project_id(ids)
    #   b = t.billable
    #   logger.debug "THE BILLABE VALUES INSIDE LOOP : #{b}"
    # end
    
    billable = params[:Tasks]
    logger.debug "The PARAMS INSIDE CUSTOMER REPORT ARE: #{@billable}"
   
    @users = @users.flatten.uniq
    @users_array = @users.pluck(:id)
    logger.debug("THE USER IDS ARE: #{@users_array}")
    @projects = @customer.projects
    @dates_array = @customer.find_dates_to_print(params[:proj_report_start_date], params[:proj_report_end_date], params["current_week"], params["current_month"])
    @week_array = @customer.find_week_id(params[:proj_report_start_date], params[:proj_report_end_date],@users_array)
    logger.debug("THE WEEK ID YOU ARE LOOKING FOR ARE :  #{@week_array}")
    if params[:user] == "" || params[:user] == nil
      if params[:project] == "" || params[:project] == nil
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], @users_array, @projects, params["current_week"], params["current_month"], billable)
      else
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], @users_array, params[:project], params["current_week"], params["current_month"], billable)
      end
    else
      if params[:project] == "" || params[:project] == nil
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], [params[:user]], @projects, params["current_week"], params["current_month"], billable)

      else
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], [params[:user]], params[:project], params["current_week"], params["current_month"], billable)
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
    project_id  = params[:project_id]
    project = Project.find params[:project_id]	
    
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
    @users = User.where("parent_user_id IS ? && (customer_id IS ? OR customer_id = ?)", nil, nil , params[:customer_id])
    @employment_type = EmploymentType.where(customer_id: @customer.id)
    @users_eligible_to_be_manager = User.where("customer_id = ? OR admin = ?",@customer.id, 1)
    logger.debug("customer-dynamic-update- @users_eligible_to_be_manager #{@users_eligible_to_be_manager.inspect}")
    @user_with_pm_role = User.where("customer_id =? and pm=?", @customer.id, true)
    # @users= User.all
    logger.debug("CUSTOMER EMPLOYEES ARE: #{@users.inspect}")
    # @vacation_requests = VacationRequest.where("customer_id= ? and status = ?", params[:customer_id], "Requested" or "CancelRequest")
    @vacation_requests = VacationRequest.where("customer_id = ? and status IN (?,?)", params[:customer_id],"CancelRequest", "Requested")

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
    #MyMailer.confirmation_instructions(record, token, current_user).deliver
  
    FeedbackMailer.question_email(email,type,notes).deliver
      respond_to do |format|
         format.html { redirect_to :back, notice: 'Vacation request sent successfully.' }
     end   
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :address, :city, :state, :zipcode, :regular_hours, :logo, holiday_ids: [])
    end
end
