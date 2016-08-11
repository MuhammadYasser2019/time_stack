# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ($) ->
  $("tbody").on("change", ".project_id", ->
    console.log "Inside project change" + $(this).attr('id') +  " the value selected is " + $(this).val()
    tokens = $(this).attr('id').split('_')
    console.log "token  sequence is  " + tokens[4]
    task_select_id = "week_time_entries_attributes_" + tokens[4] + "_task_id"
    build_tasks(task_select_id, $(this).val())
  )
    
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
    copy.children(".project").children().attr("id", "week_time_entries_attributes_" + count + "_project_id")
    copy.children(".task").children().attr("name", "week[time_entries_attributes][" + count + "][task_id]")
    copy.children(".task").children().attr("id", "week_time_entries_attributes_" + count + "_task_id")
    copy.children(".hour").children().attr("name", "week[time_entries_attributes][" + count + "][hours]")
    copy.children(".hour").children().attr("id", "week_time_entries_attributes_" + count + "_hours")
    copy.children(".comment").children().attr("name", "week[time_entries_attributes][" + count + "][comments]")
    copy.children(".comment").children().attr("id", "week_time_entries_attributes_" + count + "_comment")
    copy.insertAfter(i)
    input.insertAfter(i.next())
  )
  $("tbody").on("click", ".exception-check", ->
    orig = $(this)
    console.log(orig.is(":checked"))
    console.log("exception-checkr?")
    tr = $(this).parent().parent().parent("tr")
    label = tr.find(".date1").children("label")
    console.log(label.text())
    date = label.text()
    console.log("count: " + tr.siblings().length)
    if orig.is(":checked")
      console.log("already checked")
      console.log("non-date: " + tr.next().next().find(".date1").children("label").text())
      console.log("date: " + date)
      result = confirm("This will remove any added rows to from this day. Proceed?");
   	  if result
   	   tr.find("input,button,textarea,select").attr("disabled", "disabled");
   	   tr.find("a").hide()
   	   tr.siblings().each ->
   	    console.log("sibling")
        if $(this).find(".date1").children("label").text() == date
         $(this).remove()
      else
       orig.prop("checked", false)
      orig.removeAttr("disabled")
    else
      console.log("not checked")
      tr.find("input,button,textarea,select").removeAttr("disabled");
      tr.find("a").show()
      
    
  )