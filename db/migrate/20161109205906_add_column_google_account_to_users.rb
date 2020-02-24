class AddColumnGoogleAccountToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :google_account, :boolean
  end
end
