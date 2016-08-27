class WeeksController < ApplicationController
  before_action :set_week, only: [:show, :edit, :update, :destroy]

  # GET /weeks
  # GET /weeks.json
  def index
    @projects =  Project.all
    #@weeks = Week.includes("user_week_statuses").where("user_week_statuses.user_id =  ?", current_user.id)
    @weeks  = Week.left_join_weeks(current_user.id, 1).order(start_date: :desc).limit(10)
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
    @week = Week.new
    
    
  end

  # GET /weeks/1/edit
  def edit
    #@week = Week.eager_load(:time_entries).where("weeks.id = ? and time_entries.user_id = ?", params[:id], current_user.id).take
    @projects =  Project.all
    @week = Week.left_joins_user_week_statuses(current_user.id,  params[:id]).first
    
    status_ids = [1,2] 
    @statuses = Status.find(status_ids)
    @tasks = Task.where(project_id: 1)
    logger.debug "weeks_controller - edit entered method"
    if  @week.status_id.nil?
      logger.debug "weeks_controller - edit now we found that no user_week_statuses are found, hence we will try to build it now"
      @week.user_week_statuses.build
      @week.user_week_statuses.first.user_id = current_user.id
      @week.user_week_statuses.first.status_id = Status.find_by_status("NEW").id
      logger.debug "weeks_controller - edit now ready to save the new user_week_statuses as #{@week.user_week_statuses}"
      @week.save!
    end
    
    if @week.time_entries.where("time_entries.user_id = ?", current_user.id).count == 0
      logger.debug "weeks_controller - edit- looks like no time was ever saved  for this user for this week. Lets create the array now"
      7.times {  @week.time_entries.build}
      
      @week.time_entries.where("time_entries.user_id = ?", current_user.id).each_with_index do |te, i|
        logger.debug "weeks_controller - edit now for each time_entry we need to set the date  and user_id and also set the hours  to 0"
        logger.debug "year: #{@week.start_date.year}, month: #{@week.start_date.month}, day: #{@week.start_date.day}"
        logger.debug "i #{i}"
        @week.time_entries[i].date_of_activity = Date.new(@week.start_date.year, @week.start_date.month, @week.start_date.day) + i
        @week.time_entries[i].user_id = current_user.id
      end
      @week.save!
    end
  end

  # POST /weeks
  # POST /weeks.json
  def create
    @week = Week.new(week_params)

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
    logger.debug("week params: #{week_params}")
    logger.debug("week params: #{week_params["time_entries_attributes"]}")
    week_params["time_entries_attributes"].each do |t|
      logger.debug "#{t[0]}"
      if t[1]["project_id"] == ""
       t[1]["project_id"] = nil
       t[1]["task_id"] = nil
       unless TimeEntry.where(t[1]["id"]).nil?
        TimeEntry.find(t[1]["id"]).update(project_id: nil, task_id: nil)
       end
      end
      if t[0].to_i > 6
        logger.debug "t[1][project_id]: #{t[1]['project_id']}"
        logger.debug "t[1][task_id]: #{t[1]['task_id']}"
        unless TimeEntry.where(id: t[1]["id"]).present?
          TimeEntry.create(id: t[1]["id"], week_id: @week.id, project_id: t[1]["project_id"], task_id: t[1]["task_id"], hours: t[1]["hours"], user_id: current_user.id, comments: t[1]["comments"])
        end
      end
    end
    logger.debug "weeks_controller - update - params sent in are #{params.inspect}, whereas week_params are #{week_params}"
    respond_to do |format|
      if @week.update_attributes(week_params)
        week_params['time_entries_attributes'].each_with_index  do |t,i|
          logger.debug "weeks_controller - update - forcibly trying to find the activerecord  object for id  #{t[1].inspect} "
          @week.time_entries.find(t[1]['id'].to_i).update(t[1])
        end
        logger.debug "weeks_controller - update - After update @week  is #{@week.time_entries.inspect}"
        @week.save
        format.html { redirect_to "/weeks/#{@week.id}/report", notice: 'Week was successfully updated.' }
        format.json { render :show, status: :ok, location: @week }
      else
        format.html { render :edit }
        format.json { render json: @week.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def report
    @week = Week.find(params[:id])
    @projects = Project.all
    logger.debug "PROJECT quotes: #{!params[:project] == ''}"
    logger.debug "PROJECT nil: #{!params[:project] == nil}"
    logger.debug "PROJECT 1: #{!params[:project] == '5'}"
    logger.debug "PROJECT value: #{params[:project]}"
    logger.debug "commit: #{params[:commit]}"
    if params[:commit] == "Change Project"
      logger.debug "getting here?"
      @time_entries = TimeEntry.where(project_id: params[:project], week_id: @week.id, user_id: current_user.id)
    else
      @time_entries = TimeEntry.where(week_id: @week.id, user_id: current_user.id)
    end
    @hours_sum = 0
    @time_entries.each do |t|
      if !t.hours.nil?
        @hours_sum += t.hours
      end
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_week
      @week = Week.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def week_params
      params.require(:week).permit(:start_date, :end_date,
      user_week_statuses_attributes: [:id, :user_id, :status_id, :_destroy],
      time_entries_attributes: [:id, :user_id, :project_id, :task_id, :hours, :date_of_activity, :comments, :sick, :personal_day, :_destroy])
    end
end
