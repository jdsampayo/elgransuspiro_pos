# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $(document).on('keyup', "#corte_siguiente_dia", ->
    caja = $('.caja').data('value');

    new_caja = caja - $("#corte_siguiente_dia").val();
    int_part_new_caja = Math.trunc(new_caja);
    float_part_new_caja = (new_caja - int_part_new_caja).toFixed(2).split('.')[1];

    $('.caja .bolder').text(int_part_new_caja);
    $('.caja .plain:last-child').text(float_part_new_caja);

    propinas_a_entregar = $('.propinas-a-entregar').data('value');
    dinero_a_entregar = $('.dinero-a-entregar').data('value');

    new_dinero = new_caja - propinas_a_entregar;
    int_part_new_dinero = Math.trunc(new_dinero);
    float_part_new_dinero = (new_dinero - int_part_new_dinero).toFixed(2).split('.')[1];

    $('.dinero-a-entregar .bolder').text(int_part_new_dinero);
    $('.dinero-a-entregar .plain:last-child').text(float_part_new_dinero);
  )
