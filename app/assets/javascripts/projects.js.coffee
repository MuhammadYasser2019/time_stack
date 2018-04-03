# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  parse_row_id = (attr_val) ->
    row_id = attr_val.split("_")[2]
    return row_id
  $(document).on("click", ".add_comment", ->
    row_id = parse_row_id($(this).attr('id'))
    $("#comment_text_"+row_id).show()
    return
   )
   
  $(document).on('change', '.comment',  ->
    console.log("In the comment")
    if $(this).val().length >= 8
      row_id = parse_row_id($(this).attr('id'))
      $("#time_reject_" + row_id).show()
    return
   ) 
  $(document).on('click', '.reject_class', ->
    row_id = parse_row_id($(this).attr('id'))
    cotent = $('#comment_text_' + row_id).val()
    #project_url=$(location).attr('href')
    #project_id = parse_project_id(project_url)
    project_id = $("#project_id_"+row_id).val()
    $.post '/time_reject',
      id: $('#week_id_' + row_id).val(),
      project_id: project_id,
      comments: cotent,
      row_id: row_id
    return
   )
  parse_project_id = (attr_val) ->
    project_id = attr_val.split("/")[4]
    return project_id

  $(document).on("click", ".show-hours", ->
    #$('.show-hours').click ->
    row_id = parse_row_id($(this).attr('id'))
    #project_url=$(location).attr('href')
    #project_id = parse_project_id(project_url)
    project_id = $(this).parent().children("#project_id_"+row_id).val()
    console.log("THE PROJEC ID IS: " + project_id)
    $.post '/show_hours',
      user_id: $('#user_id_' + row_id).val(),
      project_id: project_id,
      week_id: $('#week_id_' + row_id).val()
    return
  )

  parse_user_id = (attr_val) ->
    user_id = attr_val.split("_")[2]
    return user_id

  $(document).on("click", ".pending-email", ->
    #$('.pending-email').click ->
    #row_id = parse_row_id($(this).attr('id'))
    #project_id = $(this).parent().children("#project_id_"+row_id).val()
    user_id = parse_user_id($(this).attr('id'))
    console.log("THE USER ID IS: " + user_id)
    $.post '/pending_email',
      user_id: user_id
    return
  )

  $(document).on("click", ".add-user-to-project", ->
  #$('.add-user-to-project').click ->
    console.log("check is clicked" +$(this).val())

    tr = $(this).parent()
    em = tr.find('.email-class').attr('value')

    console.log("em " + em)
    add_user_id = $(this).val()
    #project_url=$(location).attr('href')
    #project_id = parse_project_id(project_url)
    project_id = $(this).next('input').val()
    console.log("THE ID IS: " + project_id )
    $.get '/add_user_to_project',
      user_id: add_user_id,
      project_id: project_id
    return
  )
  $('.select-project').click ->
    p_id = $(this).val()
    console.log("click select-project- Your project id is:" + p_id)
    $.get '/dynamic_project_update',
      project_id: p_id,
      adhoc: $('#adhoc').val()
    return


  $('#project_left_table').dataTable({
    dom: 'lfrtip',
    "info": false,
    "bLengthChange": false,
    "bFilter": false,
    "paging": false,
    "order" : [[0, 'desc']]
  })

  $('.show_all_projects').click ->
    ckbox = $("#show_all_projects")
    if ckbox.is(':checked')
        check = "true"
    else
        check ="false"
    console.log("click Show all Projects Your CHECK is:" + check)
    $.get '/show_all_projects',
      checked: check
    return


  #$('.invite_user_button').click ->
#
 #   add_user_id = $(this).val()
  #  project_url=$(location).attr('href')
   # project_id = parse_project_id(project_url)
    #$.get '/add_user_to_project',
     # user_id: add_user_id,
      #project_id: project_id
    #return
  #$('#proj_report_start_date').fdatetimepicker
   # initialDate: '11-12-2016'
    #format: 'mm-dd-yyyy'
   # disableDblClickSelection: true
    #leftArrow: '<<'
    #rightArrow: '>>'
    #closeIcon: 'X'
    #closeButton: true
  #$('#proj_report_end_date').fdatetimepicker
   # initialDate: '11-12-2016'
    #format: 'mm-dd-yyyy'
    #disableDblClickSelection: true
    #leftArrow: '<<'
    #rightArrow: '>>'
    #closeIcon: 'X'
    #closeButton: true
