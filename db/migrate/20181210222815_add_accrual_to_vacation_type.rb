class AddAccrualToVacationType < ActiveRecord::Migration[5.0]
  def change
    add_column :vacation_types, :accrual, :boolean
  end
end
