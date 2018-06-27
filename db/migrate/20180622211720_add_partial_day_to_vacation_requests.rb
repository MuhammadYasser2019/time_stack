class AddPartialDayToVacationRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :vacation_requests, :partial_day, :string
  end
end
