class FeedbackMailer < ActionMailer::Base
	default to: "Mbartlett413@me.com"
	#default from: "noreply@gmail.com"

	def question_email(email, type, notes)
		#@user_email = current_user.email
		logger.debug("Are you getting the email or what? #{@user_email.inspect}")
		logger.debug("LOOKING FOR THE EMAIL #{email}")
		@email = email
		@type = type
		@notes = notes

		mail(subject:"You have Feedback")

	end 
end
