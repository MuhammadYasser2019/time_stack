class TimesheetNotificationMailer < ActionMailer::Base

	default from: 'technicalsupport@resourcestack.com'


	def mail_to_pm(user_hash)		
		user_hash.each do |pm, projects|
			@pm = User.find pm
			@projects = projects
		
			mail(to: @pm.email, subject:"Timesheet Reminder")
		end
	end 
end


