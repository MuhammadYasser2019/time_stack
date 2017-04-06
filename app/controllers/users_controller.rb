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
    @all_report_logos = ReportLogo.all
    @users_with_logo= User.where("report_logo IS NOT ? ", nil)

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
    logger.debug("IN THE SHOW USER REPORT*******: #{params.inspect}")
    @print_report = "false"
    logger.debug("******CHECKING hidden_print_report: #{params[:hidden_print_report].inspect}")
    @print_report = params[:hidden_print_report] if !params[:hidden_print_report].nil?
    if params[:id].blank?
      @user = current_user
    else
      @user = User.find(params[:id])
    end
    user_id = @user.id
    @users = User.all
    @user_projects = @user.projects
    @current_user_id = current_user.id
    time_period = params[:proj_report_start_date]..params[:proj_report_end_date]
    if !params[:project].blank?
      logger.debug "getting here?"
      @time_entries = TimeEntry.where(project_id: params[:project],user_id: @user, date_of_activity: time_period).order(:date_of_activity)
    else
      @time_entries = TimeEntry.where(user_id: @user,date_of_activity: time_period).order(:date_of_activity)
    end
    @dates_array = @user.find_dates_to_print(params[:proj_report_start_date], params[:proj_report_end_date])
    @daily_totals = Array.new
    full_date_array = @user.full_date_array(params[:proj_report_start_date], params[:proj_report_end_date])
    full_date_array.each do |d|
      hours_today = TimeEntry.where(user_id: @user.id, date_of_activity: d).sum(:hours)
      logger.debug "HOURS TODAY: #{hours_today}"
      @daily_totals << hours_today
    end
    @days_of_week  = @user.days_of_week(params[:proj_report_start_date], params[:proj_report_end_date])
    @weekend_days = Array.new
    count = 0
    @days_of_week.each do |d|
      count += 1
      if d == "Sun" || d == "Sat"
        @weekend_days << count
      end
    end
    @consultant_hash = @user.user_times(params[:proj_report_start_date], params[:proj_report_end_date], @user)
    if params[:proj_report_start_date]
      start_split = params[:proj_report_start_date].split("-")
      @start_date = start_split[1] + "/" + start_split[2] + "/" + start_split[0]
    end
    if params[:proj_report_end_date]
      end_split = params[:proj_report_end_date].split("-")
      @end_date = end_split[1] + "/" +end_split[2] + "/" + end_split[0]
    end
    @hours_sum = 0
    @time_entries.each do |t|
      if !t.hours.nil?
        @hours_sum += t.hours
      end
    end
    split_url = request.original_url.split("/")
    period_url = split_url[4].split("?")
    logger.debug "PERIOD DEBUG #{period_url}"
    logger.debug "SPLIT: #{split_url[0]} and #{split_url[2]} and #{split_url[3]} and #{split_url[4]}"
    if period_url[1].nil?
      @url = split_url[0] + "//" + split_url[2] + "/" + split_url[3] + "/" + period_url[0] + ".xlsx"
    else
      @url = split_url[0] + "//" + split_url[2] + "/" + split_url[3] + "/" + period_url[0] + ".xlsx" + "?" + period_url[1]
    end
    logger.debug "URLLLLLLL: #{@url}"
    respond_to do |format|
      format.xlsx
      format.html{}

    end
  end

  def user_profile
    @user = current_user
  end

  def assign_report_logo_to_user
    logger.debug("the PARAMETERS for assigning RL: #{params.inspect}")
    user = User.find(params[:user])
    report_logo_id = params[:report_logo]
    user.report_logo = report_logo_id
    user.save
    logger.debug("The use email is : #{user.email}")

    respond_to do |format|
        format.html { redirect_to "/admin", notice: 'Logo assigned to User' }
    end
  end



  private
  
    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :password_confirmation, :user, :cm, :pm, :admin, :proxy, :invited_by_id)
    end
end