$(function() {
    $('#lookup-button').click(function() {
        var linkId = $('#link-id').val();
        $.ajax({
            type: 'GET',
            url: '/api/links/' + linkId,
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            success: function(data, status, xhr) {
                $('#link').html('<a href="' + data.uri + '">' + data.uri + '</a>');
            },
            error: function(xhr, status, error) {
                $('#link').html('<span>' + error + '</span>');
                $('#link-id').addClass('hasErrors');
            }
        });
    });
    $('#button_shorten').click(function() {
        var link = $('#link_uri').val();
        $.ajax({
            type: 'POST',
            url: '/api/links',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            data: JSON.stringify({uri: link}),
            success: function(data, status, xhr) {
                $('#shortened_link').val(data.internal_uri);
                $('#errors').html('');
                $('#link_uri').removeClass('hasErrors');
                $('#copy_button').tooltip('destroy').tooltip({
                    container: 'body',
                    title: 'click here to copy',
                    placement: 'right',
                    trigger: 'manual'
                }).tooltip('show');
                setTimeout(function() {
                    $('#copy_button').tooltip('hide');
                }, 3000);
            },
            error: function(xhr, status, error) {
                errorList = '<ul>';
                errors = xhr.responseJSON.errors;
                errors.forEach(function(error) {
                    errorList += '<li>';
                    errorList += error;
                    errorList += '</li>';
                });
                errorList += '</ul>';
                $('#main.errors').html(errorList);
                $('#link_uri').addClass('hasErrors');
            }
        });
    });
    var client = new ZeroClipboard(document.getElementById("copy_button"));
    client.on("ready", function(readyEvent) {
        client.on("copy", function(event) {
            var clipboard = event.clipboardData;
            clipboard.setData("text/plain", $('#shortened_link').val());
            $('#copy_button').tooltip('destroy').tooltip({
                container: 'body',
                title: 'copied!',
                placement: 'right',
                trigger: 'manual'
            }).tooltip('show');
            setTimeout(function() {
                $('#copy_button').tooltip('hide');
            }, 3000);
        });
    });
    $('#lookup-link').click(function() {
        $('#lookup-link').hide();
        $('#back-link').show();
        $('#main').hide();
        $('#lookup').show();
        $('#copy_button').tooltip('hide');
    });
    $('#back-link').click(function() {
        $('#back-link').hide();
        $('#lookup-link').show();
        $('#lookup').hide();
        $('#main').show();
        $('#link').html('');
        $('#link-id').val('');
        $('#link-id').removeClass('hasErrors');
    });
});
