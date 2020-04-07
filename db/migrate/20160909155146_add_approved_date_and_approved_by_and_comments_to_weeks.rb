class AddApprovedDateAndApprovedByAndCommentsToWeeks < ActiveRecord::Migration
  def change
    add_column :weeks, :approved_date, :datetime
    add_column :weeks, :approved_by, :integer
    add_column :weeks, :comments, :text
  end
end
