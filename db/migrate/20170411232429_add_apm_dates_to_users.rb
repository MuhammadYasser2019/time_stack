class AddApmDatesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :start_apm, :datetime
    add_column :users, :end_apm, :datetime
  end
end
