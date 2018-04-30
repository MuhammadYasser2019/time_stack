module Api
	class UsersController < ActionController::Base
		def get_all_users
			
			#user = User.find_by(email: params[:email])
			user = User.first
			logger.debug("the users email : #{user}")
      		
			render :json=> {:user=> user}
		end 

		
	end
end
