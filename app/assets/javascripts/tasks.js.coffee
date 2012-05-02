$ ->
  $('.datepicker').datepicker
    format: 'yyyy-mm-dd'

  $("#new_task_container").on "shown", ->
    $('#new-task-link').fadeOut(250)

  $("#new_task_container").on "hidden", ->
    $('#new-task-link').fadeIn(250)

  if $(".alert")[0]?
    $("#new_task_container").collapse('show')