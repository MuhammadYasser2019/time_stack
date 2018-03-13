class AddActiveToProjectsUsers < ActiveRecord::Migration
  def change
    add_column :projects_users, :active, :boolean
  end
end
