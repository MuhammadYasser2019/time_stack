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
  end

  # GET /customers/1/edit
  def edit
    customer_holiday_ids = CustomersHoliday.where(customer_id: @customer.id).pluck(:holiday_id)
    @projects = @customer.projects
    @holidays = Holiday.where(global:true).or(Holiday.where(id: customer_holiday_ids))
    @customer_holiday = CustomersHoliday.new
    @invited_users = User.where("invited_by_id = ?", current_user.id)
    @users = User.where("customer_id IS ? OR customer_id = ?", nil , params[:id])
    # @users= User.all
    logger.debug("CUSTOMER EMPLOYEES ARE: #{@users.inspect}")
    @vacation_requests = User.where("vacation_start_date != ? and customer_id= ?", "NULL", params[:id])
    logger.debug("************User requesting VACATION: #{@vacation_requests.inspect} ")
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

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
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to edit_customer_path(@customer), notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
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

  def add_user_to_customer
    customer_id = params[:customer_id]
    user = User.find(params[:user_id])
    logger.debug("CUSTOMER ID: #{customer_id}***********AND USER CUSTOMER ID: #{user.customer_id}")
    logger.debug("COMPARE:    #{user.customer_id.to_i == customer_id.to_i}")
    if !customer_id.blank? && !user.blank?
      if user.customer_id.to_i == customer_id.to_i
        user.customer_id = nil
        user.save
        logger.debug("REMOVING THE USER*******")
        @verb = "Removed"
      else
        user.customer_id = customer_id
        user.save
        logger.debug("Adding THE USER*******")
        @verb = "Added"
      end
    end
    respond_to do |format|
     format.js
   end
  end

  def vacation_request
    @user = current_user
    user_customer = @user.customer_id 
    sick_leave = params[:sick_leave]
    personal_leave = params[:personal_leave]
    logger.debug("sick_leave: #{sick_leave}******personal_leave: #{personal_leave} ")
    customer_manager = Customer.find(user_customer).user_id
    logger.debug("customer manager id IS : #{customer_manager}")
    vacation_start_date = params[:vacation_start_date]
    vacetion_end_date = params[:vacation_end_date]
    @user.vacation_start_date = vacation_start_date
    @user.vacation_end_date = vacetion_end_date
    @user.save

    VacationMailer.mail_to_customer_owner(@user, customer_manager,vacation_start_date,vacetion_end_date ).deliver
    
    
  end

  def approve_vacation
    @user = User.find(params[:user_id])
    logger.debug("888888888888888888 : #{@user.inspect}")
    @row_id = params[:row_id]
    customer_manager = current_user
    VacationMailer.mail_to_vacation_requestor(@user, customer_manager ).deliver
    @user.vacation_start_date = "NULL"
    @user.vacation_end_date = "NULL"
    @user.save
    respond_to do |format|
      format.html {flash[:notice] = "Approved"}
      format.js
    end
  end

  def reject_vacation
    @user = User.find(params[:user_id])
    logger.debug("888888888888888888 : #{@user.inspect}")
    @row_id = params[:row_id]
    customer_manager = current_user
    VacationMailer.rejection_mail_to_vacation_requestor(@user, customer_manager ).deliver
    @user.vacation_start_date = "NULL"
    @user.vacation_end_date = "NULL"
    @user.save
    respond_to do |format|
      format.html {flash[:notice] = "Rejected"}
      format.js
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :address, :city, :state, :zipcode, holiday_ids: [])
    end
end
