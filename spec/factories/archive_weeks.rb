FactoryBot.define do
  factory :archive_week do
		id 1
		date_of_activity  {DateTime.now}
		hours nil
		activity_log  nil
		task_id nil
		week_id nil
		user_id nil
		created_at nil
		updated_at nil
		project_id nil
		sick nil
		personal_day nil
		updated_by nil
		status_id nil
		approved_by nil
		approved_date nil
		time_in nil
		time_out nil
		vacation_type_id nil
	  end 
end
