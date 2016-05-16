class ChangeTimeEntriesDate < ActiveRecord::Migration
  def change
    rename_column :time_entries, :date, :date_of_activity
  end
end
