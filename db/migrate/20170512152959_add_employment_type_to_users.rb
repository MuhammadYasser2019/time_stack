class AddEmploymentTypeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :employment_type, :integer
  end
end
