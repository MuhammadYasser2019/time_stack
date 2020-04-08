class AddProxyToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :proxy, :integer
  end
end
