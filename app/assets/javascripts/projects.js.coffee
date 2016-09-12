# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  parse_row_id = (attr_val) ->
    row_id = attr_val.split("_")[2]
    return row_id
  $(".add_comment").click ->
    alert ("hello classes..." + $(this).attr('id')) 
    row_id = parse_row_id($(this).attr('id'))
    alert("row id is " + row_id)
    $("#comment_"+row_id).show()
    return
  return