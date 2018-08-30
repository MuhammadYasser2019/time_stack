class AddWeekIdToUserNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :user_notifications, :week_id, :integer
  end
end
