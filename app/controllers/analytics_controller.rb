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


    @cus_projects = Project.where(customer_id: params[:customer_id])
    @customer_id = params[:customer_id]
    @project_ids = @cus_projects.pluck(:id)
    @project_names = Array.new
    @cus_projects.each do |pn|
    	pname = pn.name
    	@project_names << pname[0..10]
    end
    @user_count = Array.new
    @project_ids.each do |pu|
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
    	#temp_sign_in = un.last_sign_in_at
    	#@user_sign_in << temp_sign_in.to_formatted_s(:short)
        @user_sign_in << un.last_sign_in_at
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


    @lineSize = {
        :height => 350,
        :width => 500
    }

    @month_names = Date::MONTHNAMES

    @line_data = Hash.new
    new_hash = Hash.new
    sub_hash = Hash.new
    appr_hash = Hash.new
    rej_hash = Hash.new

    time_entries_array = Array.new
    week_ids_array = Array.new
    submitted_count_array = [0,0,0,0,0,0,0,0,0,0,0,0,0]
    approved_count_array = [0,0,0,0,0,0,0,0,0,0,0,0,0]
    rejected_count_array = [0,0,0,0,0,0,0,0,0,0,0,0,0]
    new_count_array = [0,0,0,0,0,0,0,0,0,0,0,0,0]
    all_week_ids_array = Array.new
    #weeks_count_array = Array.new

    @project_ids.each do |pids|
        week_ids_array = TimeEntry.where(project_id: pids).pluck(:week_id).uniq
        all_week_ids_array.push(week_ids_array)
        wids_array_count = week_ids_array.count
        logger.debug("TIME ENTRIES WITH PROJECT ID COUNT #{wids_array_count}")
    end

    logger.debug("WEEK ID #{all_week_ids_array.flatten}")

    all_week_ids_array.flatten.each do |wid|
        logger.debug("WEEK IDS IN THE ARRAY #{wid}")
        w = Week.find(wid)
        if w.status_id == 1 && w.start_date.year == Date.today.year
            logger.debug("WEEK Is           #{w}")
            month = w.start_date.month

            new_count_array[month] +=1 
            
            logger.debug("MONTH #{month} ,    #{new_count_array}")

        elsif w.status_id == 2 && w.start_date.year == Date.today.year
            month = w.start_date.month
            submitted_count_array[month] +=1

        elsif w.status_id == 3 && w.start_date.year == Date.today.year
            month = w.start_date.month
            approved_count_array[month] +=1

        elsif w.status_id == 4 && w.start_date.year == Date.today.year
            month = w.start_date.month
            rejected_count_array[month] +=1
        end
    end

    #linedata

    @line_data[:datasets] = Array.new
    @line_data[:labels] = @month_names
    new_hash[:data] = new_count_array
    new_hash[:backgroundColor] = colors_array
    new_hash[:borderColor] = colors_array
    new_hash[:borderWidth] = 1
    new_hash[:fill] = false
    new_hash[:label] = "New Weeks"
    @line_data[:datasets][0] = new_hash
    sub_hash[:data] = submitted_count_array
    sub_hash[:backgroundColor] = colors_array
    sub_hash[:borderColor] = colors_array
    sub_hash[:borderWidth] = 1
    sub_hash[:fill] = "false"
    sub_hash[:label] = "Submitted Weeks"
    @line_data[:datasets][1] = sub_hash 
    appr_hash[:data] = approved_count_array
    appr_hash[:backgroundColor] = colors_array
    appr_hash[:borderColor] = colors_array
    appr_hash[:borderWidth] = 1
    appr_hash[:fill] = "false"
    appr_hash[:label] = "Approved Weeks"
    @line_data[:datasets][2] = appr_hash 
    rej_hash[:data] = rejected_count_array
    rej_hash[:backgroundColor] = colors_array
    rej_hash[:borderColor] = colors_array
    rej_hash[:borderWidth] = 1
    rej_hash[:fill] = "false"
    rej_hash[:label] = "Rejected Weeks"
    @line_data[:datasets][3] = rej_hash 


    @line_data_2 = Hash.new
    vac_hash = Hash.new
    vacation_request_ids = VacationRequest.where(customer_id: params[:customer_id])
    vacation_types = VacationType.where(customer_id: params[:customer_id]).pluck(:vacation_title)


    @line_data_2[:datasets] = Array.new
    @line_data_2[:labels] = vacation_types
    vac_hash[:data] = [110,20,30]
    vac_hash[:backgroundColor] = colors_array
    vac_hash[:borderColor] = colors_array
    vac_hash[:borderWidth] = 1
    vac_hash[:fill] = false
    vac_hash[:label] = "Vacation"
    @line_data_2[:datasets][0] = vac_hash 

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
