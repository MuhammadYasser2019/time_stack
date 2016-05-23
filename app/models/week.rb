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
  
  def self.left_join_weeks(some_user, status)
    weeks = Week.arel_table
    user_week_statuses = UserWeekStatus.arel_table

    weeks = weeks.join(user_week_statuses, Arel::Nodes::OuterJoin).
                  on(weeks[:id].eq(user_week_statuses[:week_id]), user_week_statuses[:user_id].eq(some_user)).
                  join_sources
                  
    joins(weeks)
  end
  def self.left_joins_user_week_statuses(some_user, week_id)
    weeks = Week.joins("LEFT JOIN `user_week_statuses` ON `user_week_statuses`.`week_id` = `weeks`.`id` AND `user_week_statuses`.`user_id` = #{some_user}").
      where("weeks.id = ?",week_id).
      select("weeks.id AS id, weeks.start_date AS start_date, weeks.end_date AS end_date, user_week_statuses.user_id  AS  user_id, user_week_statuses.status_id AS status_id")
  end
end
