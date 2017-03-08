# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  parse_row_id = (attr_val) ->
    row_id = attr_val.split("_")[2]
    return row_id
  $(".add_comment").click ->
    row_id = parse_row_id($(this).attr('id'))
    $("#comment_text_"+row_id).show()
    return

  $('.comment').change ->
    if $(this).val().length >= 8
      row_id = parse_row_id($(this).attr('id'))
      $("#time_reject_" + row_id).show()
    return

  $('.reject_class').click ->
    row_id = parse_row_id($(this).attr('id'))
    cotent = $('#comment_text_' + row_id).val()
    $.post '/time_reject',
      id: $('#week_id_' + row_id).val(),
      comments: cotent,
      row_id: row_id
    return

  parse_project_id = (attr_val) ->
    project_id = attr_val.split("/")[4]
    return project_id

  $('.show-hours').click ->
    row_id = parse_row_id($(this).attr('id'))
    project_url=$(location).attr('href')
    project_id = parse_project_id(project_url)
    $.post '/show_hours',
      user_id: $('#user_id_' + row_id).val(),
      project_id: project_id,
      week_id: $('#week_id_' + row_id).val()
    return

  $('.add-user-to-project').click ->
    console.log("check is clicked" +$(this).val())

    tr = $(this).parent()
    em = tr.find('.email-class').attr('value')

    console.log("em " + em)
    add_user_id = $(this).val()
    project_url=$(location).attr('href')
    project_id = parse_project_id(project_url)
    $.get '/add_user_to_project',
      user_id: add_user_id,
      project_id: project_id
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