$(document).ready(function() {
    var nowTemp = new Date();
    var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
    $('.datepicker').datepicker({
        format: "yyyy/mm/dd",
        onRender: function(date) {
           return date.valueOf() < now.valueOf() ? 'disabled' : '';
        }
    }).on('changeDate', function(ev){
        if (ev.date.valueOf() >= now.valueOf()){
            $(this).datepicker('hide');
        }
    });
    $(".form").validate();
});