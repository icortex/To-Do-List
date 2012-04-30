$ ->
  today = new Date()
  $('.datepicker').datepicker
    autoClose: true
    startDate: today
    format: 'yyyy-mm-dd'