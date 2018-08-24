class AddSendNotificationToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :deactivate_notifications, :boolean, :default => false
  end
end
