class FeedbackMailer < ActionMailer::Base
	default to: 'Mbartlett413@me.com'
	default from: 'timestackrsi@gmail.com'

	def question_email(email, type, notes)
		logger.debug("LOOKING FOR THE EMAIL #{email}")
		@email = email
		@type = type
		@notes = notes
		mail(subject:"You have Feedback") 
	end 
end
 