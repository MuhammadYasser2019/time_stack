class ShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]

  def index

  end

  def new
    @shift = Shift.new
    @customer_id = params[:customer_id]
    @customer_id = current_user.customer_id unless @customer_id
    @start_time_hour = ""
    @start_time_minute = ""
    @start_time_period = ""
    @end_time_hour = ""
    @end_time_minute = ""
    @end_time_period = ""
  end

  def create
    start_time = params[:start_time_hour] + ':' + params[:start_time_minute] + " " + params[:start_time_period]
    end_time = params[:end_time_hour] + ':' + params[:end_time_minute] + " " + params[:end_time_period]
    @shift = Shift.new(shift_params)
    @shift.start_time = start_time
    @shift.end_time = end_time
    if @shift.save
      redirect_to customers_path
    end
  end

  def edit
    start_time_split = @shift.start_time.split(":")
    @start_time_hour = start_time_split[0]
    @start_time_minute = start_time_split[1].split(" ")[0]
    @start_time_period = start_time_split[1].split(" ")[1]
    end_time_split = @shift.end_time.split(":")
    @end_time_hour = end_time_split[0]
    @end_time_minute = end_time_split[1].split(" ")[0]
    @end_time_period = end_time_split[1].split(" ")[1]
    @customer_id = @shift.customer_id
  end

  def update
    start_time = params[:start_time_hour] + ':' + params[:start_time_minute] + " " + params[:start_time_period]
    end_time = params[:end_time_hour] + ':' + params[:end_time_minute] + " " + params[:end_time_period]
    if @shift.update(shift_params.merge(start_time: start_time, end_time: end_time))
      redirect_to customers_path
    end
  end

  def show
  end

  def destroy
    if @shift.destroy!
      redirect_to customers_path
    end
  end

  private

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:name, :start_time, :end_time, :regular_hours, :incharge, :active, :default, :location, :capacity, :customer_id)
  end
end