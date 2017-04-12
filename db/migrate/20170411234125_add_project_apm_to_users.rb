class AddProjectApmToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :project_apm, :integer
  end
end
