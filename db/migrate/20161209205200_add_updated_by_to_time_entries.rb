class AddUpdatedByToTimeEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :time_entries, :updated_by, :integer
  end
end
