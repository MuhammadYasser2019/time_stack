class AddNameAndOauthTokensToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :oauth_token, :string
  end
end
