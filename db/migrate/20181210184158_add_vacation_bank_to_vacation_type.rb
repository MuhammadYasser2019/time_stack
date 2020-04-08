class AddVacationBankToVacationType < ActiveRecord::Migration[5.0]
  def change
    add_column :vacation_types, :vacation_bank, :integer
  end
end
