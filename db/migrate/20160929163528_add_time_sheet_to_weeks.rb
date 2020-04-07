class AddTimeSheetToWeeks < ActiveRecord::Migration
  def change
    add_column :weeks, :time_sheet, :string
  end
end
