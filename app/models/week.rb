class Week < ActiveRecord::Base
  has_many :time_entries
  accepts_nested_attributes_for :time_entries, allow_destroy: true, reject_if: proc { |time_entries| time_entries[:date].blank? }
  
  def current_user_time_entries
    logger.debug "Week - current_user_time_entries entering"
    TimeEntry.where(week_id: id)
    logger.debug "Week - current_user_time_entries leaving"
  end
end
