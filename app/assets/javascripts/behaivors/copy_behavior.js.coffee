$(document).ready ->
  $(".copy_button").each ->
    button = @
    client = new ZeroClipboard(button)
    client.on "load", (client) ->
      client.on "dataRequested", (client, args) ->
        element = $(client.elements()[0])
        copy_text = element.parent().prev().val()
        console.log element
        client.setText copy_text
        element.tooltip(container: 'body', title: 'copied!', placement: 'left', trigger: 'manual')
        element.tooltip('show')
        callback = ->
          element.tooltip('hide')
        setTimeout callback, 3000
        return
