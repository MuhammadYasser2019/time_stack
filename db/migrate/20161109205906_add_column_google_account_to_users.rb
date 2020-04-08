class AddColumnGoogleAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_account, :boolean
  end
end
