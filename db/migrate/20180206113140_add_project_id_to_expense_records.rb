class AddProjectIdToExpenseRecords < ActiveRecord::Migration
  def change
    add_column :expense_records, :project_id, :integer
  end
end