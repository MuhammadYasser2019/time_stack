class CreateArchiveWeeks < ActiveRecord::Migration[5.0]
  def change
    create_table :archive_weeks do |t|

      t.timestamps
    end
  end
end
