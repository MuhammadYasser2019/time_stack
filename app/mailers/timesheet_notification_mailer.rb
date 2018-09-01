class TimesheetNotificationMailer < ActionMailer::Base

	default from: 'technicalsupport@resourcestack.com'


	def mail_to_user(week, user)
		logger.debug("LOOKING FOR THE EMAIL #{user.id}")
		@user = user
		@week = week
		mail(to: user.email, subject:"Timesheet Reminder") 
	end 
end
 