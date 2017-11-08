# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  $(document).on("change", ".pm_project_id", ->
    console.log "Inside project change" + $(this).attr('id') +  " the value selected is " + $(this).val()    
    user_select_id = "adhoc_pm_id"
    tr = $(this).parent().parent("tr")
    console.log("tr: " + tr)
    build_users(user_select_id, $(this).val())
  )

  build_users = (user_id, project_id) ->
    $('#'+user_id).find('option').remove()
    console.log "Inside  build_tasks  " +  user_id +  "  " + project_id
    my_url = '/available_users/'+project_id
    $.ajax my_url,
      data: {}
      type: 'GET',
      async: false,
      dataType: 'json'
      success: (data, textStatus, jqXHR) ->
        $my_data = data
        console.log "data is  " + data.length + " my_data is  " + $my_data.length
        for item in $my_data
          console.log "data is "+item.code + "  "  + item.description
          $('#'+user_id).append($("<option></option>").attr("value",item.id).text(item.email))

  $('#report').hide()

  parse_row_id = (attr_val) ->
    row_id = attr_val.split("_")[4]
    return row_id

  parse_customer_row_id = (attr_val) ->
    row_id = attr_val.split("_")[0]
    return row_id

  parse_user_id = (attr_val) ->
    user_id = attr_val.split("_")[1]
    return user_id

  parse_vacation_request_id = (attr_val) ->
    row_id = attr_val.split("_")[3]
    return row_id

  parse_customer_id = (attr_val) ->
    customer_id = attr_val.split("/")[4]
    return customer_id

  $('.select-customer').click ->
    c_id = $(this).val()
    console.log("click select-customer- Your customer id is:" + c_id)
    $.get '/dynamic_customer_update',
      customer_id: c_id
    return


  $(document).on('click', '.resend_vacation_request', ->
    console.log("REQUEST")
    vacation_request_row_id = parse_row_id($(this).attr('id'))
    console.log("VR ROW ID: " + vacation_request_row_id)
    vacation_request_id = parse_vacation_request_id($(this).attr('id'))
    console.log(vacation_request_id)

    start = $('#vacation_start_' + vacation_request_row_id).attr('value')
    end = $('#vacation_end_' + vacation_request_row_id).attr('value')
    $('#vacation_comment_' + vacation_request_row_id).text("hi")
    #$('#vacation_comment_' + vacation_request_row_id).trigger
    c = $('#vacation_comment_' + vacation_request_row_id).text()

    console.log("START :" + start + "END :" + end + "COMMENT" + c)
    $.get "/resend_vacation_request",
      vacation_request_id: vacation_request_id,
      vacation_start: start,
      vacation_end: end
    return
  )

  parse_email_user_id = (attr_val) ->
   user_id = attr_val.split("_")[2]
   return user_id

  $(document).on("click", ".customers-pending-email", ->
    #$('.pending-email').click ->
    #row_id = parse_row_id($(this).attr('id'))
    #project_id = $(this).parent().children("#project_id_"+row_id).val()
    user_id = parse_email_user_id($(this).attr('id'))
    console.log("THE USER ID IS: " + user_id)
    $.post '/customers_pending_email',
      user_id: user_id
    return
  )

  $(document).on('click', '.remove-user-from-customer', ->
    console.log("customers.js- romove customer")
    user_id = parse_user_id($(this).attr('id'))
    console.log("customer.js- remove form customer "+"user_id: "+ $(this).attr('id'))
    row = parse_customer_row_id($(this).attr('id'))
    console.log("customer.js- remove from customer "+"row_id: "+ row )
    customer_url=$(location).attr('href')
    customer_id = parse_customer_id(customer_url)
    $.get "/remove_user_from_customer",
      user_id: user_id,
      customer_id: customer_id,
      row: row
    return
  )

  $(document).on("click", ".shared_user", ->
    console.log("check is clicked" +$(this).val())

    shared_user_id = $(this).val()
    $.get '/shared_user',
      user_id: shared_user_id,
  )

  $(document).on("click", ".add_pm_role", ->
    console.log("check is clicked" +$(this).val())

    user_id = $(this).val()
    $.get '/add_pm_role',
      user_id: user_id,
  )

  $('#show_reports').DataTable({
    dom: 'Bfrtip',
    "retrieve": true,
    buttons: [ 'excel', 'pdf']
  
  })


  $(document).on("change", ".pm_user_id", ->
    console.log "Inside user change" + $(this).attr('id') +  " the value selected is " + $(this).val()  
    pm_user_id = $(this).val() 
    project_id = $(this).closest('tr').attr('id')
    $("#pm_user_id_"+project_id).val(pm_user_id)
  )

  $(document).on('click', '.assign_pm', (event)->
    event.preventDefault()
    customer_id = $('#customer_id').val()
    project_id = $(this).closest('tr').attr('id')
   
    my_url = '/assign_pm/'+customer_id

    $.post my_url,

      "project_id": project_id,
      "user_id": $("#pm_user_id_"+project_id).val(),
  )
    


