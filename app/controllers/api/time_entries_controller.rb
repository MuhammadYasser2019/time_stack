module Api
    class TimeEntriesController<BaseController
        def get_weekly_time_entries
            begin
				@user_id = @user.id
				@weeks = Week.where(:user_id=>@user_id).order(:id=> 'desc').select("id as timeEntryID, start_date as startDate, end_date as endDate, status_id as status").as_json 
				render json: format_response_json({
					message: 'Weekly entries retrieved!',
					status: true,
					result: @weeks
				})        
			rescue
			    render json: format_response_json({
					message: 'Failed to retrieve weekly time entries!',
					status: false
				})
			end
		end

		def get_daily_time_entries
			begin
				@week_id = params[:week_id] 

				@entries = TimeEntry.where(:week_id=> @week_id).select("id as entryID, date_of_activity as date,status_id as entryStatus").as_json
				# also get shift start as shiftStartTime, shift end as shiftEndTime

				render json: format_response_json({
					message: 'Daily entries retrieved!',
					status: true,
					result: @entries
				})        
			rescue
			    render json: format_response_json({
					message: 'Failed to retrieve daily time entries!',
					status: false
				})
			end
		end	

		def submit_weekly_time_entry
			begin
				@week_id = params[:week_id] #12071

				Week.where(:id=> @week_id).update(status_id: 2)
				
				@rows_affected = TimeEntry.where(:week_id=> @week_id).update_all(status_id: 2)

				@success = @rows_affected > 0

				render json: format_response_json({
					message: @success? 'Successfully submitted weekly entry!': "Failed to submit weekly entry!",
					status: @success
				})        
			rescue
			    render json: format_response_json({
					message: 'Failed to submit weekly entry!',
					status: false
				})
			end
		end	

		def get_user_projects
			begin
                @user_id = @user.id
                @project_ids = ProjectsUser.where(:user_id=>@user_id).pluck(:id)
				@projects=Project.where(:id=> @project_ids).select("id as projectID, name as projectName").as_json

				render json: format_response_json({
					message: 'User projects retrieved!',
					status: true,
					result: @projects
				})        
			rescue
			    render json: format_response_json({
					message: 'Failed to retrieve user projects!',
					status: false
				})
			end
		end	

		def get_project_tasks
			begin
				@project_id = params[:project_id]
				@tasks=Task.where(:project_id=> @project_id).select("id as taskID, code as taskName").as_json

				render json: format_response_json({
					message: 'Project tasks retrieved!',
					status: true,
					result: @projects
				})        
			rescue
			    render json: format_response_json({
					message: 'Failed to retrieve projects tasks!',
					status: false
				})
			end
		end	
    end
end