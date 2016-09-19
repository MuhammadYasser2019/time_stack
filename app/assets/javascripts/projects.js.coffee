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
      id: $('#user_id_' + row_id).val(),
      comments: cotent,
      row_id: row_id
    return

  $('.show-project-reports').click ->
    console.log("button clicked")
    path = "/show_project_reports"
    console.log("after path")
    $.get path,{ }