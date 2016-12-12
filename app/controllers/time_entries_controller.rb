class TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /time_entries
  # GET /time_entries.json
  def index
    # TODO this entire code will only be done for non customer reviewers role. (SAMEER 05022016)
    @weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    prev_sunday = Date.today.sunday
    
    if Date.today == prev_sunday 
      @curr_week = Week.find_by_start_date(Date.today)
    else
      prev_sunday = Date.today.monday-1
      @curr_week = Week.find_by_start_date( Date.today.monday-1 ) 
    end
    @time_entries = TimeEntry.where("week_id = ? and user_id = ?", @curr_week.id, current_user.id) 
    if @time_entries.empty?
      @weekdays.each_with_index do |w, i|
        t = TimeEntry.new
        t.user = current_user
        t.week = @curr_week
        t.date_of_activity = @curr_week.start_date + i
        t.hours = 0
        logger.debug "time_entries_controller - index - time_entry is #{t.inspect}"
        t.save!
        @time_entries.push(t)
      end
      logger.debug "time_entries_controller - index - @time_entries is #{@time_entries.inspect}"
    end  
  end

  # GET /time_entries/1
  # GET /time_entries/1.json
  def show
  end

  # GET /time_entries/new
  def new
    @time_entry = TimeEntry.new
    @time_entry.user = current_user
    @time_entry.week = find_current_week
  end

  # GET /time_entries/1/edit
  def edit
  end

  # POST /time_entries
  # POST /time_entries.json
  def create
    @time_entry = TimeEntry.new(time_entry_params)
    respond_to do |format|
      if @time_entry.save
        format.html { redirect_to @time_entry, notice: 'Time entry was successfully created.' }
        format.json { render :show, status: :created, location: @time_entry }
      else
        format.html { render :new }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_entries/1
  # PATCH/PUT /time_entries/1.json
  def update
    respond_to do |format|
      if @time_entry.update(time_entry_params)
        format.html { redirect_to @time_entry, notice: 'Time entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_entry }
      else
        format.html { render :edit }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_entries/1
  # DELETE /time_entries/1.json
  def destroy
    @time_entry.destroy
    respond_to do |format|
      format.html { redirect_to time_entries_url, notice: 'Time entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_entry
      @time_entry = TimeEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_entry_params
      params.require(:time_entry).permit(:date, :hours, :activity_log, :task_id, :week_id, :user_id, :sick, :personal_day,
                                  :updated_by)
    end
end
