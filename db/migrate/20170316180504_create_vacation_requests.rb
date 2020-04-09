class CreateVacationRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :vacation_requests do |t|
    	t.belongs_to :customer, index: true
    	t.belongs_to :user, index: true
    	t.timestamps
    end
  end
end
