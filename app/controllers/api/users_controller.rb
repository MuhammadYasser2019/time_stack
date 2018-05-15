module Api
  class UsersController < ActionController::Base
		include UserHelper
		before_action :authenticate_user_from_token, except: [:login_user, :update_date, :post_data]
			
		def login_user	
		    user = User.find_by(email: params[:email])
		    logger.debug("the user email you sent is : #{params[:email]}")
		
			if user&.valid_password?(params[:password])
		      	render json: user.as_json(only: [:email, :authentication_token, message: "success"]),status: :created
		    else
		      	render :json => {status: :unauthorized ,message: "The email or password was incorrect. Please try again"}
	    	end
	    end 

	   #def pmcm_login
	   #	 logged_in_user = User.find_by(email: params[:email])

	   #	 if user.pm = 1  || user.cm = 1 || user.admin = 1
	   #	 	user_role = 1
	   #	 else 
	   #	 	user_role = 0
	   #	 end 
	   #	 #pass user role in json to angular. Have angular load a seperate page
	   #	 #seperate page will call another api
	   #end 
	   #def approve_reject
	   #	logged_in_user = User.find_by(email: params[:email]).customer_id
	   #	applicable_weeks = Weeks.where("status_id = ? and user_id = ?" 2,logged_in_user)

 
	   #end 

	    def update_date
	    	
			#Used to find week_id for avaliable_entries 
			time_entry = TimeEntry.where("date_of_activity = ? && user_id = ?", Date.today.to_datetime, params[:email]).first
			logger.debug("Today's Time Entry #{time_entry.inspect}")
			gimme = time_entry.week_id
			logger.debug("GIMME THAT ID #{gimme}")

	    	#Find new time_entry with matching parameters
	    	update_date = TimeEntry.where("date_of_activity = ? and user_id = ?", params[:date_of_activity], params[:email])
	    	logger.debug("the new entry is #{update_date.inspect}")
	    
	    	#needed for dropdown
	    	avaliable_entries = TimeEntry.where("week_id = ?", gimme).collect{|w| w.date_of_activity.strftime("%Y/%m/%d")}

	    		render :json => {status: :ok, timeEntry_hash: {
															id: update_date[0].id,
															user_id: update_date[0].user_id,
															week_id: update_date[0].week_id,
															task_id: update_date[0].task_id,
															project_id: update_date[0].project_id,
															hours: update_date[0].hours,
															vacation_type_id: update_date[0].vacation_type_id,
															activity_log: update_date[0].activity_log,
														},
														date_of_activity: avaliable_entries

					}
	    end 
		def get_time_entry
			#get user
			user = User.find_by_email(params[:email])
			#get user ID
			myuser = User.find_by_email(params[:email]).id 
			logger.debug("User ID is #{myuser}")
		
			
			#Find Current Time Entry
			time_entry = TimeEntry.where("date_of_activity = ? && user_id = ?", Date.today.to_datetime, user.id)
			logger.debug("Today's Time Entry #{time_entry.inspect}")
			

			#TimeEntries To Load Into DropDown
			avaliable_entries = TimeEntry.where("week_id = ?", time_entry[0].week_id).collect{|w| w.date_of_activity.strftime("%Y/%m/%d")}
			logger.debug("These are entries Avaliable #{avaliable_entries.inspect}")

			#List Projects
			avaliable_projects = Project.where(:customer_id => user.customer_id).collect{|w| w.name}
			logger.debug (" These are the avaliable project's #{avaliable_projects.inspect}")

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
														date_of_activity: avaliable_entries,
														name: avaliable_projects

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