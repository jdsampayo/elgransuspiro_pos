$(document).on "turbolinks:load", ->

  $('.datepicker').datepicker
    format: 'yyyy-mm-dd',
    language: 'es',
    endDate: '0d'
