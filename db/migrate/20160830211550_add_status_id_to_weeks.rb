class AddStatusIdToWeeks < ActiveRecord::Migration[5.0]
  def change
    add_column :weeks, :status_id, :integer
  end
end
