class AddPartialDayToTimeEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :time_entries, :partial_day, :string
  end
end
