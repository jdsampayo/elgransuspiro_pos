# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  $(document).on('keyup', "#corte_siguiente_dia", ->
    $("#corte_sobre").val($("#corte_total").val() - $("#corte_pagos_con_tarjeta").val() - $("#corte_siguiente_dia").val())
  )
