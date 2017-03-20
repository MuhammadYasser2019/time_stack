class AddVacationStartDateAndVacationEndDateToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :vacation_start_date, :datetime
    add_column :users, :vacation_end_date, :datetime
  end
end
