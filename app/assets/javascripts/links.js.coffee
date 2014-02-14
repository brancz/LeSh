# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
	$('form.new_link').on 'ajax:success', (xhr, data, status) ->
		$('#shortened_link').val data.short_link
		$('#shortened_link').parent().addClass 'has-success'
		$('#copy_button').tooltip(container: 'body', title: 'click here to copy', placement: 'right', trigger: 'manual')
		$('#copy_button').tooltip('show')
		$('#link_uri').parent().removeClass 'has-error'
		callback = ->
			$('#copy_button').tooltip('hide')
			$('#shortened_link').parent().removeClass 'has-success'
		setTimeout callback, 3000

	$('form.new_link').on 'ajax:error', (xhr, status, error) ->
		$('#link_uri').parent().addClass 'has-error'
		$('#link_uri').tooltip(animation: true, container: 'body', title: 'your link is invalid', placement: 'bottom', trigger: 'manual')
		$('#link_uri').tooltip('show')
		callback = ->
			$('#link_uri').tooltip('hide')
			$('#link_uri').parent().removeClass 'has-error'
		setTimeout callback, 3000

	if $('#copy_button').length > 0
		$('#copy_button').clip = new ZeroClipboard $("#copy_button"),
			moviePath: "ZeroClipboard.swf"

		clip.on "dataRequested", (client, args) ->
			clip.setText $("#shortened_link").val()
			$('shortened_link').parent().removeClass 'has-success'

	$('#button_get_info').click ->
		$.ajax(
			url: "/links/info/" + $('#uri').val() + ".json"
			success: (data, status, xhr) ->
				$('#shorted_uri').attr('href', data.uri)
				$('#shorted_uri').html(data.uri)
			error: (xhr, status, error) ->
				uri = $('#root_url').html()
				$('#shorted_uri').attr('href', uri)
				$('#shorted_uri').html("Provided link does not exist")
		)
