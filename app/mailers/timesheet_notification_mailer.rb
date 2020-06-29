class TimesheetNotificationMailer < ActionMailer::Base

	default from: 'technicalsupport@resourcestack.com'


	def mail_to_pm(pm, users)		
		@pm = User.find pm
		#@users = users.uniq.join(", ")
		results = []
		users.each do |user|
			u = User.where(:email => user ,:is_active => true).last	
	  		project_users =  ProjectsUser.where(:user_id => u.id) if u.present?
	  		if project_users.present?
				project_users.each do|p_u|
					row                 =  Hash.new
					row["project_id"]   = p_u.id
					row["project_name"] = p_u.project.name
					row["user_email"] 	= u.email
					results << row
				end
			end
		end
		@results  = results.group_by{|r| r["project_id"]}
		mail(to: @pm.email, subject:"Timesheet Reminder")
	end 
end


