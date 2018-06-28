var CONFIG = {
	last_message_time: Date.parse(new Date())
};

function onSubmit(){
	var msg=$("#entry").val().replace("\n", "");
	$.ajax({
		type: "POST",
		url: "process_post",
		data: "msg="+msg,
		dataType:'json',
		success: function(ret){
			$("#entry").val("");
		}
	});
}

function addMessage(data){
	var html = '<h4>'+data.msg +' 	'+ data.timestamp +'</h4>';
	$("#tabcontent").append(html);
}


function longPoll (data) {
	if(data && data.length>=1){
		var len = data.length;
		for(var i = 0;i<len;i++){
			msg = data[i];
			if (msg._timestamp > CONFIG.last_message_time){
				CONFIG.last_message_time = msg._timestamp;
			}
			addMessage(msg);
		}
	}

	$.ajax({
		type: "POST",
		url: "recv",//
		data: {
			since: CONFIG.last_message_time
		},
		dataType: "json",
		error: function (response,status,xhr) {
			longPoll(data);
		},
		 success: function (data) {
			longPoll(data);
		}
	});
	//console.log("last_message_time is"+CONFIG.last_message_time);
}

(function() {
	longPoll();
})();
