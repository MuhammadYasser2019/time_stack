class AnalyticsController < ApplicationController
	def index
		#data_table = GoogleVisualr::DataTable.new
		# Add Column Headers
		#data_table.new_column('string', 'Year' )
		#data_table.new_column('number', 'Sales')
		#data_table.new_column('number', 'Expenses')

		# Add Rows and Values
		#data_table.add_rows([
		#	['2004', 1000, 400],
		#	['2005', 1170, 460],
		#	['2006', 660, 1120],
		#	['2007', 1030, 540]
		#])
		#option = { width: 1000, height: 1000, title: 'Resource stack' }
		#@chart = GoogleVisualr::Interactive::AreaChart.new(data_table, option)
		u = User.all
	    @user_count = u.count
	    c = Customer.all
	    @cus_count = c.count
		@pieSize = {
	    :height => 500,
	    :width => 500
	  	}

	  	@pieData = [
	        {
	          value: @user_count,
	          color:"#F7464A",
	          highlight: "#FF5A5E",
	          label: "Total Users"
	        },
	        {
	          value: @cus_count,
	          color: "#46BFBD",
	          highlight: "#5AD3D1",
	          label: "Total Customers"
	        },
	        {
	          value: 100,
	          color: "#FDB45C",
	          highlight: "#FFC870",
	          label: "Yellow"
	        },
	        {
	          value: 40,
	          color: "#949FB1",
	          highlight: "#A8B3C5",
	          label: "Grey"
	        },
	        {
	          value: 120,
	          color: "#4D5360",
	          highlight: "#616774",
	          label: "Dark Grey"
	        }

	     ].to_json

	    @barSize = {
	    :height => 500,
	    :width => 500
	  	}

	  	@barData = [
	        {
	          value: @user_count,
	          color:"#F7464A",
	          highlight: "#FF5A5E",
	          label: "Total Users"
	        },
	        {
	          value: @cus_count,
	          color: "#46BFBD",
	          highlight: "#5AD3D1",
	          label: "Total Customers"
	        },
	        {
	          value: 120,
	          color: "#4D5360",
	          highlight: "#616774",
	          label: "Dark Grey"
	        }

	     ].to_json
	end
end
