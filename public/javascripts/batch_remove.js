
$(document).ready(function(){
    $('#addrow').click(function(){
        var thisRow = $('#boulders > tbody:last');
        $( thisRow ).clone().insertAfter( thisRow ).find( 'input:text' ).val( '' );
    });
});
