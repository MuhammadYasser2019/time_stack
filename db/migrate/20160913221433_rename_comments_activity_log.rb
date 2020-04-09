class RenameCommentsActivityLog < ActiveRecord::Migration
  def change
	rename_column :time_entries, :comments, :activity_log
  end
end
