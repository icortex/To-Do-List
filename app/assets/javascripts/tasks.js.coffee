$ ->
  $('.datepicker').datepicker
    format: 'yyyy-mm-dd'

  $("#new_task").on "shown", ->
    $('#new-task-link').fadeOut(250)

  $("#new_task").on "hidden", ->
    $('#new-task-link').fadeIn(250)
