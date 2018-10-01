class UsersController < ApplicationController 
  load_and_authorize_resource 
  acts_as_token_authentication_handler_for User


  def self.unread
      where(:read => false)
  end
 
#Choose Approved Timesheet to Reset
  def reset 
    logger.debug("YOU ARE WATCHING: #{params.inspect}")
    @weeks = Week.where("status_id =? ", 3)
    @users = User.where(:customer_id => params[:customer_id])
    logger.debug("The current users are #{@users.inspect}")
  end 

   def default_week
    default_user = User.find(params[:user_email])
    @show_week = Week.where("status_id = ? and user_id = ?", 3, params[:user_email])
    logger.debug("The default user ID is #{params[:user_email]}") 
    respond_to do |format|
      format.js
    end 
  end 

  #finds the week with a users email, & Week start date/APPROVED status
  def approved_week
    default_user = User.find_by_id(params[:email])
    @approved_week = Week.where("user_id = ? and status_id =? and id = ?", params[:email],3,params[:start_date])
    @time_entry = TimeEntry.where(:week_id => @approved_week)
    logger.debug("TimeEntry ID #{@time_entry.inspect}")
    logger.debug("USER ID #{params[:email]}")
    logger.debug "Week ID #{params[:start_date]}"
   end 

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
            end
            if week.status_id ==1 || week.status_id ==5 
              week.status_id = Status.find_by_status("EDIT").id
              if params["time_entry_#{u.id}_#{count}_#{d}"].present?
                te = TimeEntry.find (params["time_entry_#{u.id}_#{count}_#{d}"])
                te.hours = params["hours_#{u.id}_#{count}_#{d}"]
                te.task_id = params["task_id_#{u.id}_#{count}"]
                te.save
              else
                TimeEntry.where("user_id=? && date_of_activity=? && task_id is null", u.id, d.to_date.to_s ).delete_all
                new_day = TimeEntry.new
                new_day.date_of_activity = d.to_date.to_s
                new_day.project_id = @p.id
                new_day.task_id = params["task_id_#{u.id}_#{count}"]
                new_day.hours = params["hours_#{u.id}_#{count}_#{d}"]
                new_day.updated_by = current_user.id
                new_day.user_id = week.user_id
                new_day.status_id = 5
            
                week.time_entries.push(new_day)
              end
              week.save
              vacation(week)
            end 
          end
        end
      end
    end
    redirect_to show_project_reports_path(id: @project_id, proj_report_start_date: params[:proj_report_start_date], proj_report_end_date: params[:proj_report_end_date])
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


    logger.debug("What are the dates, #{params[:proj_report_start_date].inspect}")
    if params[:proj_report_start_date].blank?
      logger.debug("Are you in here or there$%^&$%^&$%&$%^&$%&$%^^&$%^&$%^&$&$%^&$%^&$%^&$%^&$%^&")
      params[:proj_report_start_date] = Date.today.strftime("%Y-%m-01")
      params[:proj_report_end_date] = Date.today.strftime("%Y-%m-%d")
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
    logger.debug "HELLO THERE: #{@dates_array}"
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
    @customer = Customer.where(id: current_user.customer_id).first
    logger.debug "URLLLLLLL: #{@url}"

    respond_to do |format|
      format.xlsx
      format.html{}

    end
  end


  def show_user_weekly_reports

    if params[:id].blank?
      @user = current_user
    else
      @user = User.find(params[:id])
    end
    if params[:month].blank?
      logger.debug("Are you in here or there$%^&$%^&$%&$%^&$%&$%^^&$%^&$%^&$&$%^&$%^&$%^&$%^&$%^&")
      proj_report_start_date = Time.now.beginning_of_month
      proj_report_end_date = Time.now.end_of_month
    else
      mon = Time.now.month-params[:month].to_i

      proj_report_start_date = (Time.now.beginning_of_month - mon.month)
      proj_report_end_date = (Time.now.end_of_month - mon.month)
    end 

    user_id = @user.id
    @users = User.all
    user_project = @user.projects
    @user_projects = user_project & Project.where(customer_id: current_user.customer_id)

    @current_user_id = current_user.id
    time_period = proj_report_start_date..proj_report_end_date

    time_entries = TimeEntry.where(user_id: @user.id,date_of_activity: time_period).order(:date_of_activity)
    week_array = time_entries.collect(&:week_id).uniq
    @time_hash = {}
    week_array.each do |w|
      @time_hash[w] = {}
      week = Week.find w
      if params[:project_id].present?
        time_entry = week.time_entries.where(project_id: params[:project_id],date_of_activity: time_period).order(:date_of_activity)
      else
        time_entry = week.time_entries.where(project_id: @user_projects.collect(&:id), date_of_activity: time_period).order(:date_of_activity)
      end  
      time_entry.each do |t|  
        @time_hash[w][t.project_id] ||= {}
        @time_hash[w][t.project_id][t.task_id] ||= Array.new(7,0.0) if (t.date_of_activity.wday != 0 && t.project_id.present?) || (t.date_of_activity.wday != 7 && t.project_id.present?)
        time = t.hours.present? ? t.hours : 0.0 
        @time_hash[w][t.project_id][t.task_id][t.date_of_activity.wday] += time if @time_hash[w][t.project_id][t.task_id].present?
      end
    end
    
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

  def user_notification
    @user = current_user
    @notifications = @user.user_notifications  
    logger.debug "The NOTIFICATIONS ARE: #{@notifications}"
    @notification_ids = @user.user_notifications.pluck(:id)
    logger.debug "THE NOTIF IDS ARE: #{@notification_ids}"
    
  end

  def user_notification_date
    logger.debug(params[:created_at])
    @user = current_user
    logger.debug("USER IS : #{@user.inspect}")
    week_id = params[:week_id]
   # created_at = params[:created_at].to_date
    #week_id = Week.where("end_date = :date and user_id = :user_id", {:date => created_at - 1.day, user_id: @user.id}).pluck(:id)

    #for getting user notifications 
    @user_notification_id = UserNotification.find(params[:notification_id])
    logger.debug "THE user notification id : #{@user_notification_id}"
    
    if @user_notification_id.user_id == current_user.id
      @user_notification_id.update_attributes(:seen => Time.now)
    end

    #id = week_ids.first
     #Week.where(end_date: wek).pluck(:id)
    
    logger.debug("WEEK ID : #{week_id}")
    respond_to do |format|
      format.html { redirect_to "/weeks/#{week_id}/edit" }
    end
  end

  def get_notification
    @notification = UserNotification.where(id: params[:notification_id]).first
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
        format.html { redirect_to "/", notice: 'Defaul project set' }
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