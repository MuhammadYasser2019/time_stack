class AddRegularHoursToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :regular_hours, :decimal, default: 8.0
  end
end
