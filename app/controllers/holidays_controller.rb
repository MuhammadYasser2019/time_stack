class HolidaysController < ApplicationController
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]
  
  def new
    @holiday = Holiday.new
  end
  
  def create
    @holiday = Holiday.new(holiday_params)
   
      if @holiday.save
         if current_user.admin != true && Customer.where(user_id: current_user.id).present?
            logger.debug "YEAH THIS IS HAPPENING"
            CustomersHoliday.create(customer_id: Customer.find_by_user_id(current_user.id).id, holiday_id: @holiday.id)
         end
        if @holiday.global
          redirect_to "/admin"
        else
          redirect_to "/customers/#{Customer.find_by_user_id(current_user.id).id}/edit"
        end
      end
  end
  
  def edit
    
  end
  
  def update
     if @holiday.update(holiday_params)
      if @holiday.global
        redirect_to "/admin"
      else
        redirect_to "/customers/#{Customer.find_by_user_id(current_user.id)}"
      end
     end
  end
  
  def destroy
    global = @holiday.global
    if @holiday.destroy
      if global == true
        redirect_to "/admin"
      else
        redirect_to "/customers/#{Customer.find_by_user_id(current_user.id)}"
      end
    end
  end
  
  def check_holidays
    customer_id = params[:id]
    @holidays_ruby = {}
    @exceptions = []
    @holiday_prestrf = Customer.find(customer_id).holidays
    exceptions = User.find(current_user.id).holiday_exceptions.pluck(:holiday_ids).flatten
    exceptions.each do |e|
      @exceptions << Holiday.find(e).date.strftime("%Y-%m-%d")
    end
    @holiday_prestrf.each do |h|
      @holidays_ruby[h.date.strftime("%Y-%m-%d")] = h.name
    end
    logger.debug "holidays_ruby: #{@holidays_ruby}"
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def holiday_params
      params.require(:holiday).permit(:name, :global, :date)
    end
end