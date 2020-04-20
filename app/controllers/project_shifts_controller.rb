class ProjectShiftsController < ApplicationController
  before_action :set_shift, only: [:show, :edit, :update, :destroy]

  def index

  end

  def show

  end

  def new
    @project_shift = ProjectShift.new
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @customer = Customer.find(@project.customer_id)
      @shifts = Shift.where(customer_id: @customer.id)
      @shift_array = []
      @shifts.each do |shift|
        name_and_shift_period = shift.name + ': ' + shift.start_time + ' - ' + shift.end_time
        @shift_array << [name_and_shift_period, shift.id]
      end
      user_array = []
      User.where(id: ProjectsUser.where(project_id: @project.id)).each do |user|
        full_name = if user.first_name && user.last_name
                      user.first_name + ' ' + user.last_name
                    else
                      user.email
                    end
        user_array << [full_name, user.id]
      end
      @potential_supervisors = user_array
    end
  end

  def create
    @project_shift = ProjectShift.new(project_shift_params)
    if @project_shift.save
      redirect_to projects_path
    end
  end

  def edit
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @customer = Customer.find(@project.customer_id)
      @shifts = Shift.where(customer_id: @customer.id)
      @shift_array = []
      @shifts.each do |shift|
        name_and_shift_period = shift.name + ': ' + shift.start_time + ' - ' + shift.end_time
        @shift_array << [name_and_shift_period, shift.id]
      end
      user_array = []
      User.where(id: ProjectsUser.where(project_id: @project.id)).each do |user|
        full_name = if user.first_name && user.last_name
                      user.first_name + ' ' + user.last_name
                    else
                      user.email
                    end
        user_array << [full_name, user.id]
      end
      @potential_supervisors = user_array
    end
  end

  def update
    if @project_shift.update(project_shift_params)
      redirect_to projects_path
    end
  end

  def destroy
    if @project_shift.destroy
      redirect_to projects_path
    end
  end

  private

  def set_shift
    @project_shift = ProjectShift.find(params[:id])
  end

  def project_shift_params
    params.require(:project_shift).permit(:shift_id, :capacity, :location, :shift_supervisor_id, :project_id)
  end
end