class AddCommentToVacationRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :vacation_requests, :comment, :text
  end
end
