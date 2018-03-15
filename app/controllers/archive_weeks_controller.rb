class ArchiveWeeksController < ApplicationController
  before_action :set_archive_week, only: [:show, :edit, :update, :destroy]

  # GET /archive_weeks
  # GET /archive_weeks.json
  def index
    @archive_weeks = ArchiveWeek.all
  end

  # GET /archive_weeks/1
  # GET /archive_weeks/1.json
  def show
  end

  # GET /archive_weeks/new
  def new
    @archive_week = ArchiveWeek.new
  end

  # GET /archive_weeks/1/edit
  def edit
  end

  # POST /archive_weeks
  # POST /archive_weeks.json
  def create
    @archive_week = ArchiveWeek.new(archive_week_params)

    respond_to do |format|
      if @archive_week.save
        format.html { redirect_to @archive_week, notice: 'Archive week was successfully created.' }
        format.json { render :show, status: :created, location: @archive_week }
      else
        format.html { render :new }
        format.json { render json: @archive_week.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /archive_weeks/1
  # PATCH/PUT /archive_weeks/1.json
  def update
    respond_to do |format|
      if @archive_week.update(archive_week_params)
        format.html { redirect_to @archive_week, notice: 'Archive week was successfully updated.' }
        format.json { render :show, status: :ok, location: @archive_week }
      else
        format.html { render :edit }
        format.json { render json: @archive_week.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /archive_weeks/1
  # DELETE /archive_weeks/1.json
  def destroy
    @archive_week.destroy
    respond_to do |format|
      format.html { redirect_to archive_weeks_url, notice: 'Archive week was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_archive_week
      @archive_week = ArchiveWeek.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def archive_week_params
      params.fetch(:archive_week, {})
    end
end
