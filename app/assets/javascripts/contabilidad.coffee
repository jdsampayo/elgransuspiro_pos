$(document).on "turbolinks:load", ->

  $('.datepicker').datepicker
    format: 'yyyy-mm-dd',
    language: 'es',
    endDate: '0d'

  $('body').on 'click', 'a.eliminar', (event) ->
    event.preventDefault()
    $("#" + $(this).data('id')).remove()
    return
