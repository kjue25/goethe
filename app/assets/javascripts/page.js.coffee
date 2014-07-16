# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('table').hide()

  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    $('table').hide()  
    $("#panel_types").show()
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    panelLocation = document.getElementById('panels')
    panelLocation.innerHTML += $(this).data('fields').replace(regexp, time)
    event.preventDefault()

  $('form').on 'click', '.add_option', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('form').on 'click', '.add_panel', (event) ->
    $('table').show()
    $("#panel_types").hide()

$(document).ready(ready)
$(document).on('page:load', ready)

