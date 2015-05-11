$(document).ready(function() {

    $('#calendar').fullCalendar({
        events: '/events',
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        dayClick: function(date, jsEvent, view) {
        	$('#newEvent').modal('show')
	        // $('#calendar').fullCalendar('gotoDate', date);
	        // $('#calendar').fullCalendar('changeView', 'agendaDay');
	    }
    });

    $('#datetimepicker1').datetimepicker();
    $('#datetimepicker2').datetimepicker();
});