class AnalyticsController < ApplicationController
	def index

		user_hash = User.top(:customer_id)
		u = User.all
	    @user_count = u.count
	    c = Customer.all
	    @cus_count = c.count
		@pieSize = {
	    :height => 500,
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
	    :height => 500,
	    :width => 500
	  	}

      project_hash = Project.top(:customer_id)
      @bar_data_2 = Hash.new
      @customer_names = Array.new
      @project_counts = Array.new
      project_hash.keys.each_with_index do |p,i|
        @customer_names << Customer.find(p).name.split(" ")[0]
        @project_counts << project_hash[p]
      end
      p_hash = Hash.new
      @bar_data_2[:datasets] = Array.new
      @bar_data_2[:labels] = @customer_names
      p_hash[:data] = @project_counts
      p_hash[:backgroundColor] = colors_array
      p_hash[:borderColor] = colors_array
      p_hash[:borderWidth] = 1
      @bar_data_2[:datasets][0] = p_hash
      #@bar_data_2 << p_hash
      logger.debug "index - bar data is #{@bar_data_2}"
	  	@barData = {
					labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
					datasets: [{
												 label: '# of Votes',
												 data: [12, 19, 3, 5, 2, 3],
												 backgroundColor: [
														 'rgba(255, 99, 132, 0.2)',
														 'rgba(54, 162, 235, 0.2)',
														 'rgba(255, 206, 86, 0.2)',
														 'rgba(75, 192, 192, 0.2)',
														 'rgba(153, 102, 255, 0.2)',
														 'rgba(255, 159, 64, 0.2)'
												 ],
												 borderColor: [
														 'rgba(255,99,132,1)',
														 'rgba(54, 162, 235, 1)',
														 'rgba(255, 206, 86, 1)',
														 'rgba(75, 192, 192, 1)',
														 'rgba(153, 102, 255, 1)',
														 'rgba(255, 159, 64, 1)'
												 ],
												 borderWidth: 1
										 }]
			}.to_json

    logger.debug "old barData is #{@barData}"
	end
end
