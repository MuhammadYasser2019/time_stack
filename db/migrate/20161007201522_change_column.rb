class ChangeColumn < ActiveRecord::Migration[5.0]
  def change
    change_column :time_entries, :activity_log, :string, :limit => 500
  end
end
