class AddLogoToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :logo, :string
  end
end
