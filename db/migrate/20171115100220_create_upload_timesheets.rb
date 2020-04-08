class CreateUploadTimesheets < ActiveRecord::Migration
  def change
  	create_table :upload_timesheets do |t|
      t.integer :week_id
      t.string :time_sheet

      t.timestamps null: false
    end
  end
end