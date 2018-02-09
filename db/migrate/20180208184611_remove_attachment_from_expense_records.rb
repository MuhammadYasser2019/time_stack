class RemoveAttachmentFromExpenseRecords < ActiveRecord::Migration[5.0]
  def change
    remove_column :expense_records, :attachment, :string
  end
end
