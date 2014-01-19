# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
	$('form.new_link').on 'ajax:success', (xhr, data, status) ->
		$('#shortened_link').val data.short_link

	clip = new ZeroClipboard $("#copy_button"),
		moviePath: "ZeroClipboard.swf"

	clip.on "dataRequested", (client, args) ->
		clip.setText $("#shortened_link").val()
