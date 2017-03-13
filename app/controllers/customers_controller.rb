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
      params.require(:customer).permit(:name, :address, :city, :state, :zipcode, holiday_ids: [])
    end
end
