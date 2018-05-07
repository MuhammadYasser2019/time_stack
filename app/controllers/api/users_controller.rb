module Api
  class UsersController < ActionController::Base
		#include UserHelper
		#before_action :authenticate_user_from_token
		def login_user
			
	    user = User.find_by(email: params[:email])
	    logger.debug("the user email you sent is : #{params[:email]}")
	
			if user&.valid_password?(params[:password])
      	render json: user.as_json(only: [:email, :authentication_token, message: "success"]),status: :created
    	else
      	render :json => {status: :unauthorized ,message: "The email or password was incorrect. Please try again"}
    	end
    end 


		def get_time_entry
			user = User.find_by(email: params[:email])
			time_entry = TimeEntry.where("date_of_activity =? && user_id =? ", Time.now.to_date.to_s, user.id).first
			if time_entry
				render json: time_entry.as_json
			else
				render :json => {status: :unauthorized ,message: "The email or password was incorrect. Please try again"}
			end
			
		end

		def post_data
			#find time_entry by date and email?
			te = TimeEntry.last
			#te.project_id = params[:project]
			#te.task_id = params[:task]
			te.hours = params[:hours]
			te.vacation_type_id = params[:vacation]
			te.activity_log = params[:description]
			te.save
		end 


		

	end
end
