class CreateExternalConfigurations < ActiveRecord::Migration[5.0]
  def change
    if !table_exists?(:external_configurations)
      create_table :external_configurations do |t|
        t.integer :customer_id
        t.string :system_type
        t.string :url
        t.string :jira_email
        t.string :password
        t.string :confirm_password
        t.integer :created_by
        t.timestamps
      end
  end
  end
end
