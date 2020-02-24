class AddProjectIdToTimeEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :time_entries, :project_id, :integer
  end
end
