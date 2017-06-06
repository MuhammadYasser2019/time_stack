class WeeksController < ApplicationController
  before_action :set_week, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /weeks
  # GET /weeks.json
  def index
    @projects =  Project.all
    #@weeks = Week.includes("user_week_statuses").where("user_week_statuses.user_id =  ?", current_user.id)
    @weeks  = Week.where("user_id = ?", current_user.id).order(start_date: :desc).limit(10)
  end

  # GET /weeks/1
  # GET /weeks/1.json
  def show
    @projects =  Project.all
    @week = Week.includes("user_week_statuses").find(params[:id])
    status_ids = [1,2] 
    @statuses = Status.find(status_ids)
    @tasks = Task.all


    
  end

  # GET /weeks/new
  def new
    #@projects =  Project.joins(:projects_users).where("projects_users.user_id=? AND inactive=?", current_user.id, false )

    @week = Week.new
    @week.start_date = Date.today.beginning_of_week.strftime('%Y-%m-%d')
    @week.end_date = Date.today.end_of_week.strftime('%Y-%m-%d')
    @week.user_id = current_user.id
    @week.status_id = Status.find_by_status("NEW").id
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


    7.times {  @week.time_entries.build( user_id: current_user.id )}
      
    @week.time_entries.each_with_index do |te, i|
      logger.debug "weeks_controller - edit now for each time_entry we need to set the date  and user_id and also set the hours  to 0"
      logger.debug "year: #{@week.start_date.year}, month: #{@week.start_date.month}, day: #{@week.start_date.day}"
      logger.debug "i #{i}"
      @week.time_entries[i].date_of_activity = Date.new(@week.start_date.year, @week.start_date.month, @week.start_date.day) + i
      @week.time_entries[i].user_id = current_user.id
    end
    @week.save!

    @week_user = User.find(@week.user_id)
    vacation(@week)

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
    @tasks = Task.where(project_id: 1) if @tasks.blank?
    
    vacation(@week)
    # vr.where("status = ? && vacation_start_date >= ?", "Approved", @week.start_date)
  end

  def vacation(week)
    @user_vacation_requests = VacationRequest.where("status = ? and vacation_start_date >= ? and user_id = ?", "Approved", week.start_date, current_user.id)
    logger.debug("@@@@@@@@@@@@user_vacation_requests: #{@user_vacation_requests.inspect}")
    week.time_entries.each do |wtime|
      @user_vacation_requests.each do |v|
        if wtime.date_of_activity >= v.vacation_start_date && wtime.date_of_activity <= v.vacation_end_date 
          if v.sick == 1
            wtime.sick = true
            wtime.activity_log = v.comment 
            wtime.save
          end
          if v.personal == 1
            wtime.personal_day = true
            wtime.activity_log = v.comment
            wtime.save
          end
        end
      end
    end
  end


  # POST /weeks
  # POST /weeks.json
  def create
    @week = Week.new(week_params)
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
      # if t[0].to_i > 6
      #   logger.debug "t[1][project_id]: #{t[1]['project_id']}"
      #   logger.debug "t[1][task_id]: #{t[1]['task_id']}"
      #   unless TimeEntry.where(id: t[1]["id"]).empty?
      #     TimeEntry.create( week_id: @week.id, project_id: t[1]["project_id"], task_id: t[1]["task_id"], hours: t[1]["hours"], user_id: current_user.id, activity_log: t[1]["activity_log"], date_of_activity: t[1]["date_of_activity"])
      #   end
      # end
    end
    if params[:commit] == "Save Timesheet"
        @week.status_id = 1
        @week.time_entries.where(status_id: [nil, 4]).each do |t|
          t.update(status_id: 1)
        end
    elsif params[:commit] == "Submit Timesheet"
        @week.status_id = 2
        @week.time_entries.where(status_id: [nil, 1,4]).each do |t|
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
        @week.save
        @week.time_entries.where(user_id: nil).each do |we|
          we.update(user_id: week_user)  
          logger.debug("USER IS UPDATED ***************")
        end
        if @week.status_id == 2
          ApprovalMailer.mail_to_manager(@week, User.find(@week.user_id)).deliver
        end

        format.html { redirect_to "/weeks/#{@week.id}/report", notice: 'Week was successfully updated.' }
        format.json { render :show, status: :ok, location: @week }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_week
      @week = Week.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def week_params
      params.require(:week).permit(:id, :start_date, :end_date, :user_id, :status_id, :comments, :time_sheet, :hidden_print_report,
      time_entries_attributes: [:id, :user_id, :project_id, :task_id, :hours, :date_of_activity, :activity_log, :sick, :personal_day, :updated_by, :_destroy, :time_in, :time_out])
    end
end
