# AIRFIELD
# ActiveAdmin JS Extensions

# Send AJAX Request to Sort Pages:
sendSortRequestOfModel = (model_name) ->
  formData = $('#' + model_name + ' tbody').sortable('serialize')
  formData += "&" + $('meta[name=csrf-param]').attr("content") + "=" + encodeURIComponent($('meta[name=csrf-token]').attr("content"))
  $.ajax
    type: 'post'
    data: formData
    dataType: 'script'
    url: '/admin/' + model_name + '/sort'

jQuery ($) ->

  # Make Pages position-sortable:
  if $("body.admin_pages.index").length
    $( "#pages tbody" ).disableSelection()
    $( "#pages tbody" ).sortable
      axis: 'y'
      cursor: 'move'
      update: (event, ui) ->
        sendSortRequestOfModel("pages")

  # Make Links position-sortable:
  if $("body.admin_links.index").length
    $( "#links tbody" ).disableSelection()
    $( "#links tbody" ).sortable
      axis: 'y'
      cursor: 'move'
      update: (event, ui) ->
        sendSortRequestOfModel("links")