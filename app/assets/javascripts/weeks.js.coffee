# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  $('[id^=week_time_entries_attributes]').change ->
    console.log "Inside project change" + $(this).attr('id') +  " the value selected is " + $(this).val()
    tokens = $(this).attr('id').split('_')
    console.log "token  sequence is  " + tokens[4]
    task_select_id = "week_time_entries_attributes_" + tokens[4] + "_task_id"
    build_tasks(task_select_id, $(this).val())
    
  build_tasks = (field_id, project_id) ->
    $('#'+field_id).find('option').remove()
    console.log "Inside  build_tasks  " +  field_id +  "  " + project_id
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
  value = 0
  count = 0
  $("tbody").on("click", ".add_row", ->
    t = $(this).parent().parent("tr")
    i = $(this).parent().parent("tr").next()
    copy = t.clone()
    console.log(i.is("input"))
    if value == 0
      value = parseInt($("table input:last").attr("value")) + 1
    else
      value += 1
    if count == 0
      count = $("tbody tr").length - 1
    else
      count += 1
    console.log("VALUEEEEEE: " + value)
    input = $('<input type="hidden" value="'+ value + '" id="" name="week[time_entries_attributes][' + count + '][id]" >')
    console.log(input)
    date_value = copy.children(".date:first").children().text()
    date = $('<input type="hidden" value="' + date_value + '"  name="week[time_entries_attributes][' + count + '][date_of_activity]">')
    date.insertAfter(copy.children(".date:first").children())
    copy.children(".project").children().attr("name", "week[time_entries_attributes][" + count + "][project_id]")
    copy.children(".task").children().attr("name", "week[time_entries_attributes][" + count + "][task_id]")
    copy.children(".hour").children().attr("name", "week[time_entries_attributes][" + count + "][hours]")
    copy.children(".comment").children().attr("name", "week[time_entries_attributes][" + count + "][comments]")
    copy.insertAfter(i)
    input.insertAfter(i.next())
  )