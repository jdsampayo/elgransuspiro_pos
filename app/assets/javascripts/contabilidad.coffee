$(document).on "turbolinks:load", ->

  $('.datepicker').datepicker
    format: 'yyyy-mm-dd',
    language: 'es',
    endDate: '0d',
    orientation: 'bottom'

  $('.input-daterange').datepicker
    format: 'yyyy-mm-dd',
    language: 'es',
    endDate: '0d',
    orientation: 'bottom'

  $('.datepicker-monthly').datepicker
    format: 'yyyy-mm',
    language: 'es',
    startDate: '2014-11',
    endDate: '0d',
    startView: 1,
    minViewMode: 1,
    maxViewMode: 2,
    orientation: 'bottom'

  $('body').on 'click', 'a.eliminar', (event) ->
    event.preventDefault()
    $("#" + $(this).data('id')).remove()
    return
