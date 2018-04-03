class AddWeekIdToArchivedWeeks < ActiveRecord::Migration[5.0]
  def change
  	add_column :archived_weeks, :week_id, :integer
  end
end
