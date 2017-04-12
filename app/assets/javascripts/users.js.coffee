jQuery ($) ->	
	$('.print-user-report').click ->
	  console.log("in here")
	  $('#hidden_print_report').val("true")
	  
	  $('#user_report_form').submit()

	$(".default_project_id").change ->
		console.log("You changed the project "+ $(this).attr('id') + "the value is " + $(this).val())
		task_select_id = "default_task_id"
		build_tasks(task_select_id, $(this).val())

	build_tasks = (field_id, project_id) ->
    $('#'+field_id).find('option').remove()
    console.log "Inside build_default_tasks  " +  field_id +  "  " + project_id
    my_url = '/available_tasks/'+project_id
    $.ajax my_url,
    data: {}
    type: 'GET'
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      $my_data = data
      console.log "data is  " + data.length + " my_data is  " + $my_data.length
      for item in $my_data
        console.log "data is "+item.code + "  "  + item.description
        $('#'+field_id).append($("<option></option>").attr("value",item.id).text(item.description))
      #task_id = $('#'+field_id+' :selected').val()