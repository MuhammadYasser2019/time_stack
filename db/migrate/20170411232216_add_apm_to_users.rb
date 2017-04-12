class AddApmToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :apm, :boolean
  end
end
