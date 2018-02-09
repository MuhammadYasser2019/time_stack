class AddAttachmentToExpenseRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :expense_records, :attachment, :string
  end
end
