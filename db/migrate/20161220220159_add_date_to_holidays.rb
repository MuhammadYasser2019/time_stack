class AddDateToHolidays < ActiveRecord::Migration[5.0]
  def change
    add_column :holidays, :date, :datetime
  end
end
