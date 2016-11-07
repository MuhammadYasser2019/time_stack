class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pm, :boolean
    add_column :users, :cm, :boolean
    add_column :users, :admin, :boolean
  end
end
