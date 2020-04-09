class AddReportLogoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :report_logo, :integer
  end
end
