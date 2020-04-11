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
    if params[:project_id]
      @project = Project.find(params[:project_id])
      user_array = []
      User.where(id: ProjectUser.where(project_id: @project.id)).each do |user|
        full_name = user.first_name + ' ' + user.last_name
        user_array << [full_name, user.id]
      end
      @potential_supervisors = user_array
    end
  end

  def create
    @shift = Shift.new(shift_params)
    if params[:start_time_hour] && params[:end_time_hour]
      start_time = params[:start_time_hour] + ':' + params[:start_time_minute] + " " + params[:start_time_period]
      end_time = params[:end_time_hour] + ':' + params[:end_time_minute] + " " + params[:end_time_period]
      @shift.start_time = start_time
      @shift.end_time = end_time
    end
    if @shift.save
      if params[:type] == 'customer'
        redirect_to customers_path
      elsif params[:type] == 'project'
        redirect_to projects_path
      end
    elsif params[:type] == 'customer'
      flash.now[:error]='The End Time cannot be before the Start Time.'
      redirect_to new_shift_path(params: JSON.parse(@shift.to_json), type: params[:type])
    elsif params[:type] == 'project'
      redirect_to new_shift_path(params: JSON.parse(@shift.to_json), type: params[:type])
    end
  end

  def edit
    if @shift.start_time
      start_time_split = @shift.start_time.split(":")
      @start_time_hour = start_time_split[0]
      @start_time_minute = start_time_split[1].split(" ")[0]
      @start_time_period = start_time_split[1].split(" ")[1]
    end
    if @shift.end_time
      end_time_split = @shift.end_time.split(":")
      @end_time_hour = end_time_split[0]
      @end_time_minute = end_time_split[1].split(" ")[0]
      @end_time_period = end_time_split[1].split(" ")[1]
    end
    @customer_id = @shift.customer_id
    if params[:project_id]
      @project = Project.find(params[:project_id])
      user_array = []
      User.where(id: ProjectsUser.where(project_id: @project.id)).each do |user|
        full_name = user.first_name + ' ' + user.last_name
        user_array << [full_name, user.id]
      end
      @potential_supervisors = user_array
    end
  end

  def update
    if params[:start_time_hour] && params[:end_time_hour]
      start_time = params[:start_time_hour] + ':' + params[:start_time_minute] + " " + params[:start_time_period]
      end_time = params[:end_time_hour] + ':' + params[:end_time_minute] + " " + params[:end_time_period]
    end
    if params[:type] == 'customer' && @shift.update(shift_params.merge(start_time: start_time, end_time: end_time))
      redirect_to customers_path
    elsif params[:type] == 'project' && @shift.update(shift_params)
      redirect_to projects_path
    elsif params[:type] == 'customer'
      flash.now[:error]='The End Time cannot be before the Start Time.'
      redirect_to edit_shift_path(@shift.id, type: params[:type])
    elsif params[:type] == 'project'
      redirect_to edit_shift_path(@shift.id, type: params[:type])
    end
  end

  def show
  end

  def destroy
    customer_id = @shift.customer_id
    if @shift.destroy!
      if Shift.where(customer_id: customer_id).count == 1
        Shift.last.update(default: true)
      end
      redirect_to customers_path
    end
  end

  private

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:name, :start_time, :end_time, :regular_hours, :incharge, :active, :default, :location, :capacity, :customer_id, :shift_supervisor_id)
  end
end