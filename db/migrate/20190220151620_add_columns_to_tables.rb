class AddColumnsToTables < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :external_type_id, :integer
    add_column :tasks, :imported_from, :integer
  end
end