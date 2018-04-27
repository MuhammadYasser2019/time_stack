class AnalyticsController < ApplicationController
	def index

		user_hash = User.top(:customer_id)
		u = User.all
	  @user_count = u.count
	  c = Customer.where(user_id: 1)
	  logger.debug "user hash #{user_hash}"
	  @cus_count = c.count
		@pieSize = {
	    :height => 250,
	    :width => 500
	  }
    colors_array = ["#F7464A", "#46BFBD", "#949FB1", "#4D5360"]
    @pie_data_2 = Array.new
    user_hash.keys.each_with_index do |h, i|
      c_hash = Hash.new
      c_hash["value"] = user_hash[h]
      c_hash["color"] = colors_array[i]
      c_hash["highlight"] = "#FF5A5E"
      c_hash["label"] = Customer.find(h).name
      @pie_data_2 << c_hash
    end
    logger.debug "index - #{@pie_data_2}"

    @barSize = {
    :height => 350,
    :width => 500
    }

    #user_hash = User.top(:customer_id)
    #@project_names = Array.new
    #@user_counts = Array.new
    #user_hash.keys.each_with_index do |p,i|
    #  @project_names << Project.find(p).name.split(" ")[0]
    #  @user_counts << user_hash[p]
    #end
    #p_hash = Hash.new
    #@bar_data_2[:label] = "Hello Projects"
    #@bar_data_2[:datasets] = Array.new
    #@bar_data_2[:labels] = @project_names
    #p_hash[:data] = @user_counts
    #p_hash[:backgroundColor] = colors_array
    #p_hash[:borderColor] = colors_array
    #p_hash[:borderWidth] = 1
    #@bar_data_2[:datasets][0] = p_hash



    @cus_projects = Project.where(customer_id: params[:customer_id])
    @customer_id = params[:customer_id]
    @project_id = @cus_projects.pluck(:id)
    @project_names = Array.new
    @cus_projects.each do |pn|
    	pname = pn.name
    	@project_names << pname[0..10]
    end
    @user_count = Array.new
    @project_id.each do |pu|
    	@proj_users = ProjectsUser.where(project_id: pu)
    	@user_count << @proj_users.count 
    end
    @bar_data_2 = Hash.new
    p_hash = Hash.new
    @bar_data_2[:label] = "Hello Projects"
    @bar_data_2[:datasets] = Array.new
    @bar_data_2[:labels] = @project_names
    p_hash[:data] = @user_count
    p_hash[:backgroundColor] = colors_array
    p_hash[:borderColor] = colors_array
    p_hash[:borderWidth] = 1
    @bar_data_2[:datasets][0] = p_hash

    # Now prepare data for highcharts.

    @user_name = User.where(customer_id: params[:customer_id])
    @user_first_name = Array.new
    @user_sign_in = Array.new
    @user_name.each do |un|
    	@user_first_name << un.first_name
    	temp_sign_in = un.last_sign_in_at
    	@user_sign_in << temp_sign_in.to_formatted_s(:short)
    end

    @bar_data_3 = Hash.new
    login_hash = Hash.new
    @bar_data_3[:label] = "Hello Projects"
    @bar_data_3[:datasets] = Array.new
    @bar_data_3[:labels] = @user_first_name
    login_hash[:data] = @user_sign_in
    login_hash[:backgroundColor] = colors_array
    login_hash[:borderColor] = colors_array
    login_hash[:borderWidth] = 1
    @bar_data_3[:datasets][0] = login_hash

  end

  def bar_graph
  	#@customer_id = params[:customer_id]
    @cus_projects = Project.where(customer_id: params[:customer_id])
    @customer_id = params[:customer_id]
    @project_id = @cus_projects.pluck(:id)
    @project_names = Array.new
    @cus_projects.each do |pn|
        pname = pn.name
        @project_names << pname[0..10]
    end
    @user_count = Array.new
    @project_id.each do |pu|
        @proj_users = ProjectsUser.where(project_id: pu)
        @user_count << @proj_users.count 
    end
    respond_to do |format|
        format.js
    end
  end

  def customer_reports
    @customer_id = params[:id]
    @customer = Customer.find(@customer_id)
    @users = Array.new
    if params[:exclude_pending_users].present?
      @customer.projects.each do |p|
        @users << p.users.where.not(invitation_accepted_at: nil)
      end
    else
      @customer.projects.each do |p|
        @users << p.users
      end
    end
    @users = @users.flatten.uniq
    @users_array = @users.pluck(:id)
    logger.debug("THE USER IDS ARE: #{@users_array}")
    @projects = @customer.projects
    @dates_array = @customer.find_dates_to_print(params[:proj_report_start_date], params[:proj_report_end_date], params["current_week"], params["current_month"])
    @week_array = @customer.find_week_id(params[:proj_report_start_date], params[:proj_report_end_date],@users_array)
    logger.debug("THE WEEK ID YOU ARE LOOKING FOR ARE :  #{@week_array}")
    if params[:user] == "" || params[:user] == nil
      if params[:project] == "" || params[:project] == nil
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], @users_array, @projects, params["current_week"], params["current_month"])
      else
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], @users_array, params[:project], params["current_week"], params["current_month"])
      end
    else
      if params[:project] == "" || params[:project] == nil
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], [params[:user]], @projects, params["current_week"], params["current_month"])
      else
        @consultant_hash = @customer.build_consultant_hash(@customer_id, @dates_array, params[:proj_report_start_date], params[:proj_report_end_date], [params[:user]], params[:project], params["current_week"], params["current_month"])
      end

    end
  end
end
