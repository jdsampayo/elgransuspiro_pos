# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $('select.image-picker').imagepicker
    show_label: true

  if $('.toast').length
    $('.toast-container').addClass('front-100')

    $('.toast').on 'hidden.bs.toast', ->
      $('.toast-container').removeClass('front-100')

    $('.toast').toast('show')

  $('[data-toggle="tooltip"]').tooltip()

  $('form.simple_form select').not('.image-picker').selectize()

  checkbox_selector = "#ordenes .nested-fields input.boolean"

  $('#comanda_para_llevar').on 'click', ->
    inputs = $(checkbox_selector)

    if $(this).is(":checked")
      inputs.prop('checked','checked')
    else
      inputs.prop('checked', '')

  $(checkbox_selector).on 'click', ->
    $('#comanda_para_llevar').prop("indeterminate", false)

    if ($(checkbox_selector + ':checked').length == $(checkbox_selector).length)
      $('#comanda_para_llevar').prop('checked','checked')
    else
      $('#comanda_para_llevar').prop('checked','')
      if ($(checkbox_selector + ':checked').length > 0)
        $('#comanda_para_llevar').prop("indeterminate", true)


  $('.simple_form').on 'cocoon:after-insert', (e, insertedItem, originalEvent) ->
    $('select', insertedItem).not('.image-picker').selectize();

