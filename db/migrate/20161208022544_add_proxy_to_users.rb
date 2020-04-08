class AddProxyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :proxy, :boolean
  end
end
