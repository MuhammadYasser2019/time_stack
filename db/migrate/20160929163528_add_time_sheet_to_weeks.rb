class AddTimeSheetToWeeks < ActiveRecord::Migration[5.0]
  def change
    add_column :weeks, :time_sheet, :string
  end
end
