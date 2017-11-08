class AddSharedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :shared, :boolean
  end
end
