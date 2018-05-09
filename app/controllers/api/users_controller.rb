module Api
  class UsersController < ActionController::Base
		include UserHelper
		#before_action :authenticate_user_from_token, except: [:login_user]
		
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
		
		#get user ID
		myuser = User.find_by_email(params[:email]).id 
		logger.debug("User ID is #{myuser}")
		
		#Find Matching Week
		current_week = Week.where("user_id = ?", myuser).last
		logger.debug("current_week #{current_week.inspect}")
		
		#Find Current Time Entry
		time_entry = TimeEntry.where("date_of_activity = ? && user_id = ?", Date.today.to_datetime, myuser)
		logger.debug("Today's Time Entry #{time_entry.inspect}")
		

			render :json => {status: :ok, timeEntry_hash: {
															week_id: time_entry[0].week_id,
															task_id: time_entry[0].task_id,
															project_id: time_entry[0].project_id,
															hours: time_entry[0].hours,
															vacation_type_id: time_entry[0].vacation_type_id,
															activity_log: time_entry[0].activity_log,
														}
						}
	end

		def post_data
			#find time_entry by date and email?

			te = TimeEntry.last
			te.project_id = params[:project_id]
			te.task_id = params[:task_id]
			te.hours = params[:hours]
			te.vacation_type_id = params[:vacation_type_id]
			te.activity_log = params[:activity_log]
			te.save
		end 


		

	end
end
