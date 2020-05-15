class TimesheetNotificationMailer < ActionMailer::Base

	default from: 'technicalsupport@resourcestack.com'


	def mail_to_pm(pm, users)		
		@pm = User.find pm
		@users = users.uniq.join(", ")

		mail(to: @pm.email, subject:"Timesheet Reminder")
	end 
end
 