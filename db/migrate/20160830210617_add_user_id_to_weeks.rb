class AddUserIdToWeeks < ActiveRecord::Migration
  def change
    add_column :weeks, :user_id, :integer
  end
end
