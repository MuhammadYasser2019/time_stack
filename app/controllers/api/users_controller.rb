module Api
	class UsersController < ActionController::Base
	  before_action :doorkeeper_authorize!
	  respond_to :json

	  def index
	  	# render json: current_resource_owner.as_json(except: :password_digest)
	  	user = current_resource_owner.as_json(except: :password_digest)
	  	# logger.debug("index- current user is: #{current_resource_owner.inspect} ")
	  	present_date = Time.now.strftime("%Y-%m-%d 00:00:00")
	  	user_projects = current_resource_owner.projects
	  	logger.debug("index- projects #{user_projects.inspect} ")
	  	today_time_entries = TimeEntry.where("user_id = ? AND date_of_activity = ?", current_resource_owner.id, present_date)
	  	# logger.debug("index- today_time_entries*** #{today_time_entries.inspect}")
	  	render json: {te: today_time_entries.as_json, u: user, projects: user_projects }
	  end

	  def project_tasks
	  	if !params[:project].blank?
		  	project = Project.find_by_name(params[:project])
		  	tasks = Task.where(project_id: project.id)
		  	logger.debug("project_tasks- tasks are: #{tasks.inspect}")
		  	render json: tasks
	  	end
	  end

	  def user_updates
	  	project = Project.find_by_name(params[:project_name])
	  	time_entry = TimeEntry.find(params[:time_entry_id])
	  	hours = params[:hours]
	  	activity_log = params[:description]
	  	personal = params[:personal].nil? ? false : params[:personal]
	  	sick = params[:sick].nil? ? false : params[:sick]
	  	task = Task.find_by_description(params[:task])

	  	logger.debug("**project: #{project.inspect}****hours: #{hours}***activity_log: #{activity_log}****personal: #{personal} **sick: #{sick}** time_entry: #{time_entry.inspect} ")
	  	time_entry.project_id = project.id if !project.nil?
	  	time_entry.task_id = task.id if !task.nil?
	  	time_entry.hours = hours
	  	time_entry.activity_log = activity_log
	  	time_entry.personal_day = personal
	  	time_entry.sick = sick
	  	time_entry.save

	  end

	  def doorkeeper_unauthorized_render_options(error: nil)
    	{ json: { error: "Not authorized" } }
  	end
	  private

	  def current_resource_owner
	  	logger.debug("current_resource_owner- resource_owner_id: #{doorkeeper_token.resource_owner_id}**** #{params[:email]}")
	    User.find_by_email(params[:email]) if params[:email]
	  end

	end
end