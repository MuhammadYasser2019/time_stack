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

    def update_date
    	tester = TimeEntry.where("date_of_activity = ?" ,params[:date_of_activity])
    	logger.debug(" tester tester #{tester.inspect}")
    	update_date = TimeEntry.where("date_of_activity = ? and user_id = ?", params[:date_of_activity], params[:email])
    	logger.debug("the new entry is #{update_date.inspect}")
    		render :json => {status: :ok, timeEntry_hash: {
														id: update_date[0].id,
														week_id: update_date[0].week_id,
														task_id: update_date[0].task_id,
														project_id: update_date[0].project_id,
														hours: update_date[0].hours,
														vacation_type_id: update_date[0].vacation_type_id,
														activity_log: update_date[0].activity_log,
													}

				}

    end 
	def get_time_entry
		
		#get user ID
		myuser = User.find_by_email(params[:email]).id 
		logger.debug("User ID is #{myuser}")
	
		
		#Find Current Time Entry
		time_entry = TimeEntry.where("date_of_activity = ? && user_id = ?", Date.today.to_datetime, myuser)
		logger.debug("Today's Time Entry #{time_entry.inspect}")
		

		#TimeEntries To Load Into DropDown
		avaliable_entries = TimeEntry.where("week_id = ?", time_entry[0].week_id).collect{|w| w.date_of_activity.strftime("%Y/%m/%d")}
		logger.debug("These are entries Avaliable #{avaliable_entries.inspect}")

				render :json => {status: :ok, timeEntry_hash: {
														id: time_entry[0].id,
														user_id: time_entry[0].user_id,
														week_id: time_entry[0].week_id,
														task_id: time_entry[0].task_id,
														project_id: time_entry[0].project_id,
														hours: time_entry[0].hours,
														vacation_type_id: time_entry[0].vacation_type_id,
														activity_log: time_entry[0].activity_log,
													},
													date_of_activity: avaliable_entries

				}

	end

	def post_data
		te = TimeEntry.find_by_id(params[:id])
		logger.debug("Are you finding me #{te}")
		te.project_id = params[:project_id]
		te.task_id = params[:task_id]
		te.hours = params[:hours]
		te.vacation_type_id = params[:vacation_type_id]
		te.activity_log = params[:activity_log]
		te.save
	end 

end 
end