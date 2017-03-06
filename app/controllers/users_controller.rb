class UsersController < ApplicationController
  load_and_authorize_resource
  def user_account
    @user = current_user
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def admin
    @users = User.all
    @holidays = Holiday.where(global: true)
    @customers = Customer.where(user_id: nil)
    @invited_users = User.where("invited_by_id = ?", current_user.id)
  end
  
  def new
    @user = User.find(params[:id])
  end
  
  def create
    logger.debug "PARAMS: #{params[:users]}"
    logger.debug "id is #{params[:id]}"
    if params[:id] == nil
      params[:user].permit!.to_h.each do |p|
        logger.debug "p is #{p}"
        User.find(p[0]).update(p[1].deep_symbolize_keys())
      end
    else
      @user = User.find(params[:id])
      @user.update_attributes(user_params)
    end
    redirect_to admin_path
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def index
    @users = User.all
  end
  
  def update
    logger.debug "PARAMS: #{params.inspect}"
    if params[:id] == nil
      params.each do |p|
        logger.debug "P is #{p}"
      end
    else
      @user = User.find(params[:id])
      @user.update_attributes(user_params)
    end
    redirect_to edit_user_path(@user)
  end
  
  def proxies
    @user = User.find(params[:id])
    logger.debug "@user #{@user.inspect}"
    @proxies = Project.where(proxy: @user.id)
    logger.debug "@project #{@proxies.inspect}"
  end
  
  def proxy_users
    @user = User.find(params[:id])
    @proxy = Project.find(params[:proxy_id])
    @proxy_users = @proxy.users
  end
  
  def invite_customer
    @user = User.invite!(email: params[:email], invited_by_id: params[:invited_by_id])
    Customer.find(params[:customer_id]).update(user_id: @user.id)
    redirect_to admin_path
  end
  

  def show_user_reports
    if params[:user].blank?
      @user = current_user
    else
      @user = User.find(params[:user])
    end
    user_id = @user.id
    @users = User.all
    @user_projects = @user.projects
    # projects_array = @user_projects.pluck(:id)
    # @user_report_date_array = @user.find_dates_to_print(params[:proj_report_start_date], params[:proj_report_end_date])
    # @project_hash = @user.build_project_hash(user_id,@user_report_date_array, @user_projects,params[:proj_report_start_date], params[:proj_report_end_date])
    time_period = params[:proj_report_start_date]..params[:proj_report_end_date]
    if !params[:project].blank?
      logger.debug "getting here?"
      @time_entries = TimeEntry.where(project_id: params[:project],user_id: @user, date_of_activity: time_period).order(:date_of_activity)
    else
      @time_entries = TimeEntry.where(user_id: @user,date_of_activity: time_period).order(:date_of_activity)
    end
    @hours_sum = 0
    @time_entries.each do |t|
      if !t.hours.nil?
        @hours_sum += t.hours
      end
    end


  end



  private
  
    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :password_confirmation, :user, :cm, :pm, :admin, :proxy, :invited_by_id)
    end
  
end