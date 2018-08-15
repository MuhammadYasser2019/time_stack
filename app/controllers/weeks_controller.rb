class WeeksController < ApplicationController
  before_action :set_week, only: [:show, :edit, :update, :destroy]
  before_action :redirect_to_root, only: [:show]
  load_and_authorize_resource
  # GET /weeks
  # GET /weeks.json
  def index
    @user = current_user
    
    @default_project = @user.default_project
    @default_task = @user.default_task
    @project_tasks = Task.where(project_id: @default_project)
    logger.debug("the project tasks are: #{@project_tasks.inspect}")
    @projects =  Project.all
    #@weeks = Week.includes("user_week_statuses").where("user_week_statuses.user_id =  ?", current_user.id)
    @weeks  = Week.where("user_id = ?", current_user.id).order(start_date: :desc).limit(10)
    @projects.each do |p|
      if p.adhoc_pm_id.present? && p.adhoc_end_date.to_s(:db) < Time.now.to_s(:db)
	      p.adhoc_pm_id = nil
	      p.adhoc_start_date = nil
	      p.adhoc_end_date = nil
	      p.save
      end
    end
    if current_user.cm?
      return redirect_to customers_path
    elsif current_user.pm?
      return redirect_to projects_path
    end
  end

  # GET /weeks/1
  # GET /weeks/1.json
  def show

    #@projects =  Project.all
    #@week = Week.includes("user_week_statuses").find(params[:id])
    #status_ids = [1,2] 
    #@statuses = Status.find(status_ids)
    #@tasks = Task.all
    @projects =  Project.all
    @week = Week.includes("user_week_statuses").find(params[:id])
    status_ids = [1,2] 
    @statuses = Status.find(status_ids)
    @tasks = Task.all
  end

  def change_status
    logger.debug" PARAMTER ARE #{params}"
    #find for which user
    @time_entry = TimeEntry.where(:week_id => params[:week_id])
     @time_entry.each do |t|
      aw = ArchivedTimeEntry.new 
      aw.date_of_activity = t.date_of_activity
      aw.hours  = t.hours
      aw.activity_log = t.activity_log
      aw.task_id = t.task_id
      aw.week_id = t.week_id
      aw.user_id = t.user_id
      aw.created_at = t.created_at
      aw.updated_at = t.updated_at
      aw.project_id = t.project_id
      aw.sick = t.sick
      aw.personal_day = t.personal_day
      aw.updated_by = t.updated_by.
      aw.status_id = t.status_id
      aw.approved_by = t.approved_by
      aw.approved_date = t.approved_date
      aw.time_in = t.time_in
      aw.time_out = t.time_out
      aw.vacation_type_id = t.vacation_type_id
      aw.save
    end 
    #if archivedweek with start_date, end_date & user_id already present?
    #do not create
    w = Week.find(params[:week_id])
    #if ArchivedWeek.where("start_date =? AND user_id =? AND week_id = ?", w.start_date,w.user_id,w.id).blank?
      cw = ArchivedWeek.new
      cw.start_date = w.start_date           
      cw.end_date =w.end_date         
      cw.created_at =w.created_at                            
      cw.updated_at= w.updated_at                      
      cw.user_id = w.user_id
      cw.status_id =w.status_id    
      cw.approved_date = w.approved_date        
      cw.approved_by = w.approved_by      
      cw.comments = w.comments         
      cw.time_sheet = w.time_sheet       
      cw.proxy_user_id = w.proxy_user_id        
      cw.proxy_updated_date = w.proxy_updated_date 
      cw.week_id = w.id
      cw.reset_reason = params[:reason_for_reset]
      cw.reset_by = current_user.id
      cw.reset_date = Time.now 
      cw.save
    logger.debug("THIS IS THE WEEK BEFORE#{@week.inspect}")
   # end 
    w.status_id = 5
    w.save 
    logger.debug("THIS IS THE WEEK CHANGED #{@week.inspect}")
    respond_to do |format|
      format.js
    end 
  end 

  # GET /weeks/new
  def new
    #@projects =  Project.joins(:projects_users).where("projects_users.user_id=? AND inactive=?", current_user.id, false )
    @week = Week.new
    @week.start_date = Date.today.beginning_of_week.strftime('%Y-%m-%d')
    @week.end_date = Date.today.end_of_week.strftime('%Y-%m-%d') 
    @week.user_id = params[:user_id].present? ? params[:user_id] : current_user.id
    @week.status_id = Status.find_by_status("NEW").id
    @week.proxy_user_id = current_user.id
    @week.save!

    if current_user.id == @week.user_id
      @projects =  Project.where(inactive: [false, nil]).joins(:projects_users).where("projects_users.user_id=?", current_user.id )
    else
      @projects =  Project.where(inactive: [false, nil]).joins(:projects_users).where("projects_users.user_id=?", @week.user_id )
    end
    logger.debug("these are the projects#{@projects.inspect}")
    if !@projects.first.nil?
      @tasks = Task.where(project_id: @projects.first.id)
    end


    7.times {  @week.time_entries.build( user_id: @week.user_id, status_id: 1 )}
      
    @week.time_entries.each_with_index do |te, i|
      logger.debug "weeks_controller - edit now for each time_entry we need to set the date  and user_id and also set the hours  to 0"
      logger.debug "year: #{@week.start_date.year}, month: #{@week.start_date.month}, day: #{@week.start_date.day}"
      logger.debug "i #{i}"
      @week.time_entries[i].date_of_activity = Date.new(@week.start_date.year, @week.start_date.month, @week.start_date.day) + i
      @week.time_entries[i].user_id = @week.user_id
    end
    @week.save!

    @week_user = User.find(@week.user_id)
    emp_type = EmploymentType.find current_user.employment_type
    @vacation_types = emp_type.vacation_types.where("customer_id=? && active=?", @week_user.customer_id, true)
    vacation(@week)
    @upload_timesheet = @week.upload_timesheets.build

  end

  def copy_timesheet
    current_week_id = params[:id]
    current_week = Week.find(current_week_id)
    current_week.copy_last_week_timesheet(current_week.user_id)
    hours_array =[]
    current_week.time_entries.each do |w|
      if !w.hours.nil?
        hours_array.push("true")
      end 
    end
    hours_array
    if !hours_array.empty?

     current_week.status_id = 5 
     current_week.save
    end

    redirect_to root_path
  end

  def clear_timesheet
    logger.debug("WEEKS CONTROLLER --------------")
    current_week_id = params[:id]
    current_week = Week.find(current_week_id)
    current_week.clear_current_week_timesheet
    current_week.status_id = 1 
    current_week.save

    redirect_to root_path
  end

  # GET /weeks/1/edit
  def edit
    #@week = Week.eager_load(:time_entries).where("weeks.id = ? and time_entries.user_id = ?", params[:id], current_user.id).take
    @week = Week.find(params[:id])
    @user_id = current_user.id

    @week_user = User.find(@week.user_id)
    logger.debug("WEEK USER IS: #{@week_user.inspect}")
    if @week.status_id == 4
      logger.debug "THE STATUS IS FOOOOOOOOUOUOUOUOUOUOUOUOUOUOUOUOUUOUOUOUOOUOUOUR"
      @time_entries = @week.time_entries.where(status_id: 4)
    elsif @week.status_id == nil || @week.status_id == 1
      @time_entries = @week.time_entries.where(status_id: [nil, 1])
    elsif @week.status_id == 2 || @week.status_id == 3
      @time_entries = @week.time_entries.where(status_id: @week.status_id)
    end
    if current_user == @week.user_id
      @projects =  Project.where(inactive: [false, nil]).joins(:projects_users).where("projects_users.user_id=?", current_user.id )
    else
      @projects =  Project.where(inactive: [false, nil]).joins(:projects_users).where("projects_users.user_id=?", @week.user_id )
    end
    @week.start_date = Week.find(params[:id]).start_date.strftime('%Y-%m-%d')
    @week.end_date = Week.find(params[:id]).end_date.strftime('%Y-%m-%d')
    status_ids = [1,2]
    @statuses = Status.find(status_ids)
    emp_type = EmploymentType.find current_user.employment_type
    @vacation_types = emp_type.vacation_types.where("customer_id=? && active=?", @week_user.customer_id, true)
    @tasks = Task.where(project_id: 1) if @tasks.blank?
    @expenses = ExpenseRecord.where(week_id: @week.id)
    @week.upload_timesheets.build if @week.upload_timesheets.blank?
    vacation(@week)
    # vr.where("status = ? && vacation_start_date >= ?", "Approved", @week.start_date)
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
            wtime.save
          end
        end
      end
    end
  end

  def previous_comments
     @wuser = params[:user_id]
     @week_id = params[:week_id]
     @t = TimeEntry.where.not(activity_log: "").where("user_id= ?",params[:user_id]).order(created_at: :desc) .limit(10)
     @t.each do |t|
      logger.debug("PRINT T #{t.inspect}")
     end

     logger.debug("PREVIOUS COMMENTS WEEKS CONTROLLER_________________________ #{@t.inspect}")
     #@time_entries = @week.time_entries.where(activity_log: )
     #@week_user = User.find(@week.user_id)
     #@t = TimeEntry.find(@t.activity_log)

  end

  def add_previous_comments
    #@wuser = User.find(params[:id])
    @week_id = params[:week_id ]
    @time_entry = TimeEntry.find(params[:activity_log])

    respond_to do |format|
      format.js
    end
  end

  # POST /weeks
  # POST /weeks.json
  def create
    @week = Week.new(week_params)
    @week.proxy_user_id = current_user.id
    @week.proxy_updated_date = Time.now
    prev_date_of_activity =""
    week_params["time_entries_attributes"].each do |t|
      # store teh date of activity from previous row
      if !t[1][:date_of_activity].nil?
        prev_date_of_activity = t[1][:date_of_activity]
      else
        new_day = TimeEntry.new
        new_day.date_of_activity = prev_date_of_activity
        new_day.project_id = t[1][:project_id]
        new_day.task_id = t[1][:task_id]
        new_day.hours = t[1][:hours]
        new_day.activity_log = t[1][:activity_log]
        new_day.updated_by = t[1][:updated_by]

        @week.time_entries.push(new_day)
      end
    end

    respond_to do |format|
      if @week.save
        format.html { redirect_to @week, notice: 'Week was successfully created.' }
        format.json { render :show, status: :created, location: @week }
      else
        format.html { render :new }
        format.json { render json: @week.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /weeks/1
  # PATCH/PUT /weeks/1.json
  def update
    logger.debug("week params: #{params.inspect}")
    logger.debug("week params: #{week_params["time_entries_attributes"]}")
    week = Week.find(params[:id])
    test_array = []
    week_user = week.user_id
    logger.debug("THE USER ON THE WEEK IS: #{week_user}")
    prev_date_of_activity =""
    week_params["time_entries_attributes"].permit!.to_h.each do |t|
      # store the date of activity from previous row
      if !t[1][:date_of_activity].nil?
        logger.debug "DATE OF ACTIVITY IS NOT NIL"
        prev_date_of_activity = t[1][:date_of_activity]
      else
        logger.debug "DATE OF ACTIVITY IS ACTUALLY NIL MAN"
        new_day = TimeEntry.new
        new_day.date_of_activity = prev_date_of_activity
        new_day.project_id = t[1][:project_id]
        new_day.task_id = t[1][:task_id]
        new_day.hours = t[1][:hours]
        new_day.activity_log = t[1][:activity_log]
        new_day.updated_by = t[1][:updated_by]
        new_day.user_id = week_user
        new_day.partial_day = t[1][:partial_day]
        
        @week.time_entries.push(new_day)
      end
      logger.debug "#{t[0]}"
      if t[1]["project_id"] == ""
       t[1]["project_id"] = nil
       t[1]["task_id"] = nil

       unless TimeEntry.where(id: t[1]["id"]).empty?
        TimeEntry.find(t[1]["id"]).update(project_id: nil, task_id: nil) 
       end
      end
      if t[1]["vacation_type_id"].present? && t[1]["hours"].nil?
        TimeEntry.find(t[1]["id"]).update(hours: nil, partial_day: "false",project_id: nil, task_id: nil, activity_log: nil)
      end

      # if t[0].to_i > 6
      #   logger.debug "t[1][project_id]: #{t[1]['project_id']}"
      #   logger.debug "t[1][task_id]: #{t[1]['task_id']}"
      #   unless TimeEntry.where(id: t[1]["id"]).empty?
      #     TimeEntry.create( week_id: @week.id, project_id: t[1]["project_id"], task_id: t[1]["task_id"], hours: t[1]["hours"], user_id: current_user.id, activity_log: t[1]["activity_log"], date_of_activity: t[1]["date_of_activity"])
      #   end
      # end
      if !t[1]["hours"].blank? || !t[1]["time_in(4i)"].blank? || !t[1]["time_in(5i)"].blank? || !t[1]["time_out(4i)"].blank? || !t[1]["time_out(5i)"].blank?
       test_array.push("true")
      end

    end
    test_array
    logger.debug("TEST ARRAY ---------------------#{test_array.inspect}")
    if params[:commit] == "Save Timesheet"
        if test_array.empty?
          @week.status_id = 1
        else
          @week.status_id = 5
        end
        @week.time_entries.where(status_id: [nil,1,4]).each do |t|
          t.update(status_id: 5)
        end
    elsif params[:commit] == "Submit Timesheet"
        @week.status_id = 2
        @week.time_entries.where(status_id: [nil,1,4,5]).each do |t|
          t.update(status_id: 2)
        end
    end

    logger.debug "STATUS ID IS #{week_params[:status_id]}"
    logger.debug "weeks_controller - update - params sent in are #{params.inspect}, whereas week_params are #{week_params}"
    
    respond_to do |format|
      if @week.update_attributes(week_params)
        week_params['time_entries_attributes'].each_with_index  do |t,i|
          logger.debug "weeks_controller - update - forcibly trying to find the activerecord  object for id  #{t[1].inspect} "
          @week.time_entries.find(t[1]['id'].to_i).update(t[1]) if !t[1]['id'].blank?
        end
        logger.debug "weeks_controller - update - After update @week  is #{@week.time_entries.inspect}"
        params.require(:week).permit(upload_timesheets_attributes: [:time_sheet]).to_h.each do |attr, row|
          row.each do |i, timesheet|
            @upload_timesheet = @week.upload_timesheets.create(timesheet) if timesheet.present?
          end
        end
        @week.proxy_user_id = current_user.id
        @week.proxy_updated_date = Time.now
        @week.save
        @week.time_entries.where(user_id: nil).each do |we|
          we.update(user_id: week_user)  
          logger.debug("USER IS UPDATED ***************")
        end
        @expenses = ExpenseRecord.where(week_id: @week.id)
        logger.debug "THE EXPENSES IN WEEKS-UPDATE #{@expenses.inspect}"
        create_vacation_request(@week) if params[:commit] == "Submit Timesheet"

        if @week.status_id == 2
          ApprovalMailer.mail_to_manager(@week, @expenses, User.find(@week.user_id)).deliver
        end
        if @week.status_id == 2
          format.html { redirect_to "/weeks/#{@week.id}/report", notice: 'Week was successfully updated.' }
          format.json { render :show, status: :ok, location: @week }
        else
          format.html { redirect_to "/weeks/#{@week.id}/edit", notice: 'Week was successfully updated.' }
          format.json { render :show, status: :ok, location: @week }
        end
      else
        format.html { render :edit }
        format.json { render json: @week.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def proxy_week
    @user = User.find(params[:user_id])
    logger.debug "@user #{@user.inspect}"
    @proxy = Project.find(params[:proxy_id])
    logger.debug "@proxy #{@proxy.inspect}"
    @proxy_user = User.find(params[:proxy_user])
    logger.debug "@proxy_user #{@proxy_user.inspect}"
    @weeks = Week.where("user_id = ?", params[:proxy_user]).order(start_date: :desc).limit(10)
    logger.debug "@weeks #{@weeks.inspect}"
  end
  
  def report
    @print_report = "false"
    @print_report = params[:hidden_print_report] if !params[:hidden_print_report].nil?
    @week = Week.find(params[:id])
    @expenses = ExpenseRecord.where(week_id: @week.id)
    @user_name = User.find(@week.user_id)
    @projects = @user_name.projects
    logger.debug "PROJECT quotes: #{!params[:project] == ''}"
    logger.debug "PROJECT nil: #{!params[:project] == nil}"
    logger.debug "PROJECT 1: #{!params[:project] == '5'}"
    logger.debug "PROJECT value: #{params[:project]}"
    logger.debug "commit: #{params[:commit]}"
    if !params[:project].blank?
      logger.debug "getting here?"
      @time_entries = TimeEntry.where(project_id: params[:project], week_id: @week.id).order(:date_of_activity)
    else
      @time_entries = TimeEntry.where(week_id: @week.id).order(:date_of_activity)
    end
    @hours_sum = 0
    @time_entries.each do |t|
      if !t.hours.nil?
        @hours_sum += t.hours
      end
    end
    if @week.status_id == 3
      @approved_by = User.find(@week.approved_by)
    end
    
  end

  def print_report

  end

  # DELETE /weeks/1
  # DELETE /weeks/1.json
  def destroy
    @week.destroy
    respond_to do |format|
      format.html { redirect_to weeks_url, notice: 'Week was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def expense_records
    @week = Week.find(params[:week_id])
    if request.get?
      @projects =  Project.where(inactive: [false, nil]).joins(:projects_users).where("projects_users.user_id=?", @week.user_id ).to_a
      @week_time_entries = TimeEntry.where(project_id: params[:project], week_id: @week.id).order(:date_of_activity)
      @start_date = @week.start_date.to_date
      @end_date = @week.end_date.to_date
      logger.debug("The IN REQUEST GET WEEK STARTDATE #{@start_date.inspect} AND END DATE IS #{@end_date.inspect}")
      @week_dates = @start_date.upto(@end_date)
      @expenses = ExpenseRecord.where(week_id: @week.id)
      respond_to do |format|
        format.js
      end
    else
      logger.debug("EXPENSE RECORD- #{params.inspect}")
      @expense = ExpenseRecord.new
      @expense.expense_type = params[:expense_type]
      @expense.date = params[:date]
      @expense.description = params[:description]
      @expense.amount = params[:amount]
      @expense.week_id = params[:week_id]
      @expense.attachment = params[:attachment]
      if !params[:project_id].nil?
        @expense.project_id = Project.find_by_name(params[:project_id]).id
      end
      #logger.debug("EXPENSE FOUND #{@expense.inspect}")
      @projects =  Project.where(inactive: [false, nil]).joins(:projects_users).where("projects_users.user_id=?", @week.user_id ).to_a
      logger.debug("The PROJECTS ARE #{@projects.inspect}")
      @start_date = @week.start_date.to_date
      @end_date = @week.end_date.to_date
      logger.debug("The WEEK AFTER GET ----------- STARTDATE #{@start_date.inspect} AND END DATE IS #{@end_date.inspect}")
      @week_dates = @start_date.upto(@end_date)
      logger.debug("The 7 DATES ARE #{@week_dates.inspect}")
      @expense.save
      @expense.attachment.url
      @expense.attachment.current_path
      @expense.attachment_identifier
      @expenses = ExpenseRecord.where(week_id: @week.id)
      logger.debug("EXPENSES COUNT #{@expenses.count}")
      redirect_to edit_week_path(@week)
    end
    
    

  end

  def delete_expense
    @week = Week.find(params[:week_id])
    @expense_row = ExpenseRecord.find(params[:expense].to_i)
    logger.debug("DELETING THE ROW #{@expense_row.inspect}")
    @expense_row.destroy
    logger.debug("DELETING THE EXPENSE*******")
      #@verb = "Removed" 
    respond_to do |format|
      format.js
    end
  end

  def time_reject
    logger.debug "time_reject - entering #{params.inspect}"
    @week = Week.find(params[:id])
    @week.status_id = 4
    @week.time_entries.where(project_id: params[:project_id]).each do |t|
      t.update(status_id: 4)
    end
    @week.comments = params[:comments]
    @row_id = params[:row_id]
    @week.save!
    @user = current_user
    ApprovalMailer.mail_to_user(@week, @user).deliver
    logger.debug "time_reject - leaving"
    respond_to do |format|
      # format.html {flash[:notice] = "Reject"}
      format.js
    end
  end

  def create_vacation_request(week)
    week.time_entries.each do |wtime|
      if wtime.vacation_type_id.present? 
        user = User.find wtime.user_id
        new_vr = VacationRequest.new
        new_vr.vacation_start_date = wtime.date_of_activity
        new_vr.vacation_end_date = wtime.date_of_activity
        new_vr.user_id = wtime.user_id
        new_vr.customer_id = user.customer_id
      
        new_vr.status = "Requested"
        new_vr.vacation_type_id =wtime.vacation_type_id
        new_vr.partial_day = "true" if wtime.partial_day
        new_vr.save
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_week
      @week = Week.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def week_params
      params.require(:week).permit(:id, :start_date, :end_date, :user_id, :status_id, :comments, :time_sheet, :hidden_print_report,
      time_entries_attributes: [:id, :user_id, :project_id, :task_id, :hours, :date_of_activity, :activity_log, :sick, :personal_day, :updated_by, :_destroy, :time_in, :time_out, :vacation_type_id, :partial_day],expense_records_attributes:[:id, :expense_type, :description, :date, :amount, :attachment, :project_id])
    end

    def redirect_to_root
      redirect_to root_path
    end
end
