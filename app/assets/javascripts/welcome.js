$(function() {
	$( "#stocklookup" ).click(function() {
	  $.get("http://dev.markitondemand.com/Api/v2/Quote", {symbol: "IBM"}, function(data, status){
        alert("Data: " + data + "\nStatus: " + status);
    });
	});
});