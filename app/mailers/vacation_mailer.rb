class VacationMailer < ActionMailer::Base

	def mail_to_customer_owner(user, customer_manager,vacation_start_date,vacetion_end_date )

		@customer_manager_email = User.find(customer_manager).email
		@user_email = user.email
		@vacation_start_date = vacation_start_date
		@vacetion_end_date = vacetion_end_date
		mail(to: @customer_manager_email , subject:"Vacation Request" , from: @user_email )
	end

	def mail_to_vacation_requestor(user, customer_manager )
		@user_email = user.email
		@customer_manager_email = customer_manager.email

		mail(to: @user_email, subject:"Vacation Request Approved" , from: @customer_manager_email)
	end

	def rejection_mail_to_vacation_requestor(user, customer_manager )
		@user_email = user.email
		@customer_manager_email = customer_manager.email

		mail(to: @user_email, subject:"Vacation Request Rejected" , from: @customer_manager_email)
	end

end