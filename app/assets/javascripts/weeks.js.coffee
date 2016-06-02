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
  $('.add_row').click ->
    
    date_stamp = $(this).attr('date_stamp')
    day_value = $(this).attr('day_value')
    console.log "Clicked add  row" + day_value
    $('#mytable').each ->
      tds = '<tr>'
      iter = 0
      jQuery.each $('tr:last td', this), ->
        if(iter == 0)
          tds += '<td>' + date_stamp + '</td>'
        else if (iter == 1)
          tds += '<td>' + day_value + '</td>'
        else
          tds += '<td>' + $(this).html() + '</td>'
          console.log "html being pushed into this cell is [ " + $(this).html + "]" 
        iter++
        return
      tds += '<input type="hidden" value="" id="id"></tr>'
      if $('tbody', this).length > 0
        $('tbody', this).append tds
      else
        $(this).append tds
        return
      return
    return false    