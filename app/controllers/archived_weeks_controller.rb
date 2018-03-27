class ArchivedWeeksController < ApplicationController
  before_action :set_archived_week, only: [:show, :edit, :update, :destroy]

  # GET /archived_weeks
  # GET /archived_weeks.json
  def index
    @archived_weeks = ArchivedWeek.all
  end

  # GET /archived_weeks/1
  # GET /archived_weeks/1.json
  def show
    @archived_weeks = ArchivedWeek.all
    @statuses = Status.find_by_id(@archived_week.status_id)
    @archived_time_entries = ArchivedTimeEntry.all
    @user = User.find_by_id(@archived_week.user_id)
  end

  # GET /archived_weeks/new
  def new
    @archived_week = ArchivedWeek.new
  end

  # GET /archived_weeks/1/edit
  def edit
  end

  # POST /archived_weeks
  # POST /archived_weeks.json
  def create
    @archived_week = ArchivedWeek.new(archived_week_params)

    respond_to do |format|
      if @archived_week.save
        format.html { redirect_to @archived_week, notice: 'Archived week was successfully created.' }
        format.json { render :show, status: :created, location: @archived_week }
      else
        format.html { render :new }
        format.json { render json: @archived_week.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /archived_weeks/1
  # PATCH/PUT /archived_weeks/1.json
  def update
    respond_to do |format|
      if @archived_week.update(archived_week_params)
        format.html { redirect_to @archived_week, notice: 'Archived week was successfully updated.' }
        format.json { render :show, status: :ok, location: @archived_week }
      else
        format.html { render :edit }
        format.json { render json: @archived_week.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /archived_weeks/1
  # DELETE /archived_weeks/1.json
  def destroy
    @archived_week.destroy
    respond_to do |format|
      format.html { redirect_to archived_weeks_url, notice: 'Archived week was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_archived_week
      @archived_week = ArchivedWeek.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def archived_week_params
      params.fetch(:archived_week).permit(:reset_reason)
    end
end
