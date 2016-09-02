class AddStatusIdToWeeks < ActiveRecord::Migration
  def change
    add_column :weeks, :status_id, :integer
  end
end
