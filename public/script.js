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
                console.log(xhr.responseJSON.errors);
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
                error_list = '<ul>';
                errors = xhr.responseJSON.errors;
                errors.forEach(function(error) {
                    error_list += '<li>';
                    error_list += error;
                    error_list += '</li>';
                });
                error_list += '</ul>';
                $('#errors').html(error_list);
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
    });
    $('#back-link').click(function() {
        $('#back-link').hide();
        $('#lookup-link').show();
        $('#lookup').hide();
        $('#main').show();
    });
});
