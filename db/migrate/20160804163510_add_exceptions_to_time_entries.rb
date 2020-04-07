class AddExceptionsToTimeEntries < ActiveRecord::Migration
  def change
    add_column :time_entries, :sick, :boolean
    add_column :time_entries, :personal_day, :boolean
  end
end
