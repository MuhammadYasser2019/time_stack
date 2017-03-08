jQuery ($) ->	
	$('.print-user-report').click ->
	  console.log("in here")
	  $('#hidden_print_report').val("true")
	  
	  $('#user_report_form').submit()
