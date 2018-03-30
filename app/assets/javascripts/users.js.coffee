jQuery ($) ->	
  $(document).off("change", ".default_user");
  $(document).on("change", ".default_user", -> 
    user_email = $(this).val()
    console.log("This show the value " + user_email )
    $.get '/default_week',
    user_email: user_email 
    return
  )

  $(document).on("keyup", ".r_comment",  ->
    console.log("In the comment")
    if $(this).val().length >= 8
      $("button").prop('disabled',false); 
    return
  )

  $(document).off("click", ".reset_reason");
  $(document).on("click", ".reset_reason", ->
    week_id = $(this).attr('id').split("_")[2]
    comment = $('#reset_text').val()
    console.log("Testing Comment" + comment + "Week_id" + week_id)
    $.get '/change_status',
    reason_for_reset: comment,
    week_id: week_id 
    return
  )

  $('#show_approved_form').click

	$('.print-user-report').click ->
	  console.log("in here")
	  $('#hidden_print_report').val("true")
	  
	  $('#user_report_form').submit()

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

  $("#feature_id").change ->
    console.log("You changed the feature "+ $(this).attr('id') + "the value is " + $(this).val())
    $('.success_message').empty()
    content_id = "cke_1_contents"
    build_task(content_id, $(this).val())

  build_task = (content_id, feature_id) ->
    $('#'+content_id).find('val').empty()
    console.log "Inside comment_id  " +  content_id +  "  " + feature_id
    my_url = '/available_data/'+feature_id
    $.ajax my_url,
    data: {}
    type: 'GET'
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      $my_data = data
      for item in $my_data
        console.log "data is "+ item.feature_type
        if (item.feature_data)
          CKEDITOR.instances.feature_content_content.setData( item.feature_data)
        else
          CKEDITOR.instances.feature_content_content.setData('')
        

