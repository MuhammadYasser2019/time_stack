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
    @customers = Customer.all
    @invited_users = User.where("invited_by_id = ?", current_user.id)
    @all_report_logos = ReportLogo.all
    @users_with_logo= User.where("report_logo IS NOT ? ", nil)
    @features = Feature.all  

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

  def enter_timesheets
    @project_id = params[:proxy_id]
    @p = Project.find(@project_id)
    @users = @p.users
    @user_array = @users.pluck(:id)
    @dates_array = @p.find_dates_to_print(params[:proj_report_start_date], params[:proj_report_end_date], params["current_week"], params["current_month"])
  end

  def show_timesheet_dates  
    @project_id = params[:proxy_id]
    @p = Project.find(@project_id)
    @users = @p.users
    @user_array = @users.pluck(:id)
    @dates_array = @p.find_dates_to_print(params[:proj_report_start_date], params[:proj_report_end_date], params["current_week"], params["current_month"])
  end

  def add_proxy_row
    @project_id = params[:proxy_id]
    @p = Project.find(@project_id)
    @dates_array = @p.find_dates_to_print(params[:proj_report_start_date], params[:proj_report_end_date], params["current_week"], params["current_month"])
    @count = params[:count].to_i + 1
    @consultant = User.find params[:user_id]
    respond_to do |format|
      format.js
    end

  end

  def fill_timesheet
    @project_id = params[:proxy_id]
    @p = Project.find(@project_id)
    @users = @p.users
    @dates_array = @p.find_dates_to_print(params[:proj_report_start_date], params[:proj_report_end_date], params["current_week"], params["current_month"])
    @users.each do |u|

      week_array = []
      (0..5).each do |count|
        @dates_array.each do |d|
          if params["task_id_#{u.id}_#{count}"].present?
            week = Week.where("start_date=? && user_id=?", d.to_date.beginning_of_week.strftime('%Y-%m-%d'),u.id).first
            if week.blank?
              week = Week.new
              week.start_date = d.to_date.beginning_of_week.strftime('%Y-%m-%d')
              week.end_date = d.to_date.end_of_week.strftime('%Y-%m-%d') 
              week.user_id = u.id
              week.status_id = Status.find_by_status("EDIT").id
              week.proxy_user_id = current_user.id
              week.save!
              7.times {  week.time_entries.build( user_id: week.user_id, status_id: 5 )}
              week.save
            end
            week_array << week.id if week.status_id ==1 || week.status_id ==5 
          end
        end
        week_array.uniq.each do |w|
          week = Week.find w
          @dates_array.each_with_index do |d, p|
            week_date = Week.where("start_date=? && user_id=?", d.to_date.beginning_of_week.strftime('%Y-%m-%d'),u.id).first
            logger.debug "weeks_controller - edit now for each time_entry we need to set the date  and user_id and also set the hours  to 0"
            logger.debug "year: #{week.start_date.year}, month: #{week.start_date.month}, day: #{week.start_date.day}"
            if week_date.id == week.id && params["task_id_#{u.id}_#{count}"].present?
              te = week.time_entries.where("date_of_activity =? && task_id=?", d.to_date, params["task_id_#{u.id}_#{count}"]).first
              #wday = d.to_date.wday-1
              if te.blank?  
                new_day = TimeEntry.new
                new_day.date_of_activity = @dates_array[p].to_date.to_s
                new_day.project_id = @p.id
                new_day.task_id = params["task_id_#{u.id}_#{count}"]
                new_day.hours = params["hours_#{u.id}_#{count}_#{d}"]
                new_day.updated_by = current_user.id
                new_day.user_id = week.user_id
                new_day.status_id = 5
                
                week.time_entries.push(new_day)

              else 
                te.date_of_activity = @dates_array[p].to_date.to_s
                te.hours = te.hours.present? ? te.hours.to_i + params["hours_#{u.id}_#{count}_#{d}"].to_i : params["hours_#{u.id}_#{count}_#{d}"]
                te.user_id = week.user_id
                te.updated_by = current_user.id
                te.status_id = 5
              end
              week.save
              vacation(week)
            end
          end
        end
      end
    end
    redirect_to "/users/#{params[:id]}/proxies/#{params[:proxy_id]}/enter_timesheets  "
  end

  def vacation(week)
    @user_vacation_requests = VacationRequest.where("status = ? and vacation_start_date >= ? and user_id = ?", "Approved", week.start_date, current_user.id)
    logger.debug("@@@@@@@@@@@@user_vacation_requests: #{@user_vacation_requests.inspect}")
    week.time_entries.each do |wtime|
      @user_vacation_requests.each do |v|
        if wtime.date_of_activity >= v.vacation_start_date && wtime.date_of_activity <= v.vacation_end_date 
          if v.vacation_type_id.present?
            wtime.vacation_type_id =  v.vacation_type_id
            wtime.activity_log = v.comment 
            wtime.hours = nil
            wtime.save
          end
        end
      end
    end
  end
  
  def invite_customer
    @user = User.invite!(email: params[:email], invitation_start_date: params[:invite_start_date], invited_by_id: params[:invited_by_id])
    @user.update(invited_by_id: params[:invited_by_id])
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
      @time_entries = TimeEntry.where(project_id: params[:project],user_id: @user.id, date_of_activity: time_period).order(:date_of_activity)
    else
      @time_entries = TimeEntry.where(user_id: @user.id,date_of_activity: time_period).order(:date_of_activity)
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
    # @week = Week.where("start_date >=? and end_date <=? and user_id=?", params["proj_report_start_date"], params["proj_report_end_date"], @user.id)
    @week = @user.find_week_id(params[:proj_report_start_date], params[:proj_report_end_date], @user)
    logger.debug("THE WEEKS IN USER ARE : #{@week}")
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
    
    @default_project = @user.default_project
    @default_task = @user.default_task
    @project_tasks = Task.where(project_id: @default_project)
    logger.debug("the project tasks are: #{@project_tasks.inspect}")
  end

  def set_default_project
    logger.debug("THE PARAMETERS ARE: #{params.inspect}")
    default_project_id = params[:default_project_id]
    default_task_id = params[:default_task_id]
    user = current_user
    user.default_project = default_project_id
    user.default_task = default_task_id
    user.save

    respond_to do |format|
        format.html { redirect_to "/user_profile", notice: 'Defaul project set' }
    end
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