class ChangeFormatInTimeEntries < ActiveRecord::Migration[5.0]
  def change
    change_column :time_entries, :hours, :float
  end
end
