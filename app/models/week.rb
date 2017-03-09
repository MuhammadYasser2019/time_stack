class Week < ApplicationRecord
  has_many :time_entries, -> {order(:date_of_activity)}
  has_many :user_week_statuses
  accepts_nested_attributes_for :time_entries, allow_destroy: true, reject_if: proc { |time_entries| time_entries[:date_of_activity].blank? }
  mount_uploader :time_sheet, TimeSheetUploader

  def self.current_user_time_entries(current_user)
    logger.debug "Week - current_user_time_entries entering"
    TimeEntry.where(week_id: id, user_id: current_user.id).take
    logger.debug "Week - current_user_time_entries leaving"
  end
  
  def self.left_join_weeks(some_user, status)
    weeks = Week.arel_table
    user_week_statuses = UserWeekStatus.arel_table

    weeks = weeks.join(user_week_statuses, Arel::Nodes::OuterJoin).
                  on(weeks[:id].eq(user_week_statuses[:week_id]), user_week_statuses[:user_id].eq(some_user)).
                  join_sources
                  
    joins(weeks)
  end
  def self.left_joins_user_week_statuses(some_user, week_id)
    weeks = Week.where("weeks.id = ?", week_id).weeks_with_user_week_statuses(some_user)
  end
  
  def self.weekly_weeks
    User.all.each do |u|
      user_week_start_date = Week.where(user_id: u.id, end_date: "#{Date.today.end_of_week.strftime('%Y-%m-%d')}")
      if user_week_start_date.blank?
        @week = Week.new
        @week.start_date = Date.today.beginning_of_week.strftime('%Y-%m-%d')
        @week.end_date = Date.today.end_of_week.strftime('%Y-%m-%d')
        @week.user_id = u.id
        @week.status_id = Status.find_by_status("NEW").id
        @week.save!
        7.times {  @week.time_entries.build( user_id: u.id )}
          
        @week.time_entries.each_with_index do |te, i|
          logger.debug "weeks_controller - edit now for each time_entry we need to set the date  and user_id and also set the hours  to 0"
          logger.debug "year: #{@week.start_date.year}, month: #{@week.start_date.month}, day: #{@week.start_date.day}"
          logger.debug "i #{i}"
          @week.time_entries[i].date_of_activity = Date.new(@week.start_date.year, @week.start_date.month, @week.start_date.day) + i
          @week.time_entries[i].user_id = u.id
        end
        @week.save!
      end
    end
  end
end
