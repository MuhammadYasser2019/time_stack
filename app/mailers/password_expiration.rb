class PasswordExpiration < ActionMailer::Base

	default from: 'no-reply@chronstack.com'

	def mail_for_expiration_to_user(user,host,url,raw)
		@host = host
		@url = url

		@url = "https://" + @host + "/account/password/edit?reset_password_token=" + raw
		@raw = raw
		@user = user
		mail(to: "r.ranjantec@gmail.com", subject:"IMPORTANT: ChronStack Account Password Expiring")
		
	end

end