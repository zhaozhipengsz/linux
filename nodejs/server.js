
var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var url = require('url');
var querystring = require('querystring');
var urlencodedParser = bodyParser.urlencoded({ extended: false });

app.use(express.static('public'));
app.use(express.static('jquery'));
//app.use('client');

app.get('/client.html', function (req, res) {
    res.sendFile( __dirname + "/" + "client.html" );
})

//var messages =  [];
var channel = new function () {
	var messages = [];
	this.appendMessage = function (text,current,_current,cookie) {
		var msg = {
			'msg':text,
			'timestamp':current,
			'_timestamp':_current
		};
		messages.push(msg);
	};
	this.query = function (since,callback) {
		var matching = [];
		for(var i=0; i<messages.length; i++){
			if (messages[i]._timestamp > since){
				matching.push(messages[i]);
			}
		}
		if (matching.length != 0) {
			callback(matching);
		}else{
			callback({"msg":"暂无消息"});
		}
	}
}

app.post('/process_post', urlencodedParser, function (req, res) {
	var myDate = new Date();
	var m =myDate.getMonth() +1;
	var current = 	myDate.getFullYear()+"-"+m+"-"+myDate.getDate()+" "+myDate.getHours()+":"+myDate.getMinutes()+":"+myDate.getSeconds();
	var _current = Date.parse(new Date());
	// 输出 JSON 格式
	var response = {
    		 'msg':req.body.msg,
    		 'timestamp':current,
    		 '_timestamp': _current
	};
	channel.appendMessage(req.body.msg,current,_current);
	res.end(JSON.stringify({"code":200,"msg":"发送成功"}));
})


app.post('/recv', urlencodedParser, function (req, res) {
	var since = req.body.since;
	channel.query(since, function (messages) {
		res.end(JSON.stringify(messages));
	});
})

var server = app.listen(8081, function () {
	var host = server.address().address
	var port = server.address().port
	console.log("应用实例，访问地址为 http://%s:%s", host, port)
})
