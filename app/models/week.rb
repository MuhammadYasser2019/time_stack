class Week < ActiveRecord::Base
  has_many :time_entries
  has_many :user_week_statuses
  accepts_nested_attributes_for :time_entries, allow_destroy: true, reject_if: proc { |time_entries| time_entries[:date_of_activity].blank? }
  accepts_nested_attributes_for :user_week_statuses, allow_destroy: true, reject_if: proc { |user_week_statuses| user_week_statuses[:status_id].blank? }
  def self.current_user_time_entries(current_user)
    logger.debug "Week - current_user_time_entries entering"
    TimeEntry.where(week_id: id, user_id: current_user.id).take
    logger.debug "Week - current_user_time_entries leaving"
  end
end
