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
                $('#link-id').addClass('has-errors');
            }
        });
    });
    $('#button-shorten').click(function() {
        var link = $('#link-uri').val();
        $.ajax({
            type: 'POST',
            url: '/api/links',
            contentType: 'application/json; charset=utf-8',
            dataType: 'json',
            data: JSON.stringify({uri: link}),
            success: function(data, status, xhr) {
                $('#shortened-link').val(data.internal_uri);
                $('#main .errors').html('');
                $('#link-uri').removeClass('has-errors');
                $('#copy-button').tooltip('destroy').tooltip({
                    container: 'body',
                    title: 'click here to copy',
                    placement: 'right',
                    trigger: 'manual'
                }).tooltip('show');
                setTimeout(function() {
                    $('#copy-button').tooltip('hide');
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
                $('#main .errors').html(errorList);
                $('#link-uri').addClass('has-errors');
            }
        });
    });
    var client = new ZeroClipboard(document.getElementById("copy-button"));
    client.on("ready", function(readyEvent) {
        client.on("copy", function(event) {
            var clipboard = event.clipboardData;
            clipboard.setData("text/plain", $('#shortened-link').val());
            $('#copy-button').tooltip('destroy').tooltip({
                container: 'body',
                title: 'copied!',
                placement: 'right',
                trigger: 'manual'
            }).tooltip('show');
            setTimeout(function() {
                $('#copy-button').tooltip('hide');
            }, 3000);
        });
    });
    $('#lookup-link').click(function() {
        $('#lookup-link').hide();
        $('#back-link').show();
        $('#main').hide();
        $('#lookup').show();
        $('#copy-button').tooltip('hide');
    });
    $('#back-link').click(function() {
        $('#back-link').hide();
        $('#lookup-link').show();
        $('#lookup').hide();
        $('#main').show();
        $('#link').html('');
        $('#link-id').val('');
        $('#link-id').removeClass('has-errors');
    });
});
