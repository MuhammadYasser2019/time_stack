class FeedbackMailer < ActionMailer::Base 
	#default from: 'mason.bartlett@resourcestack.com'
	default from: 'technicalsupport@resourcestack.com'

	def question_email(email, type, notes)
		logger.debug("LOOKING FOR THE EMAIL #{email}")
		@email = email
		@type = type
		@notes = notes
		mail(to: 'technicalsupport@resourcestack.com', subject:"You have Feedback") 
	end 
end
 