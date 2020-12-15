import consumer from "./consumer"

consumer.subscriptions.create("ChatChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // console.log(data.sender_id)
    var temp = "!@#$%^&*()"+data.sender_id
    var msgdata = {
      "controller": "messages",
      "action": "create",
      "message" : {
        "body" : temp
      },
      "chat_room" : $("#chat_room").val()
    }
    $.ajax({

      type: 'POST',
      url: '/messages',
      dataType: "JSON",
      data: msgdata,
      success: function(data_ajax) {
        // alert("能够接收到！")
        var now = new Date();
        var year = now.getFullYear(); //得到年份
        var month = now.getMonth() + 1;//得到月份
        var date = now.getDate();//得到日期
        var day = now.getDay();//得到周几
        var hour = now.getHours();//得到小时
        var minu = now.getMinutes();//得到分钟
        var sec = now.getSeconds();//得到秒
        var mytime = year + "-" + month + "-" + date + " " + hour + ":" + minu + ":" + sec
        var str1 = '<li class="mar-btm">\n' +
            '  <div class="media-right">\n' +
            '\n' +
            '\n' +
            '    <img class="img-sm" src="/assets/user-icon-6122bab3bf45f283f96860b90f4e0846a25f9e68927904222c21e8d2ca26d79f.png">\n' +
            '\n' +
            '  </div>\n' +
            '  <div class="media-body pad-hor speech-right">\n' +
            '    <div class="speech">\n' +
            '      <p class="media-heading">我\n' +
            '        <text class="speech-time">\n' +
            '          <i class="fa fa-clock-o fa-fw"></i>\n' +
            mytime +
            '        </text>\n' +
            '      </p>\n' +
            '      <p style="margin-bottom: 5px; margin-top: 5px;">' + data.body + '</p>\n' +
            '    </div>\n' +
            '  </div>\n' +
            '</li>'
        var str2 = '<li class="mar-btm">\n' +
            '  <div class="media-left">\n' +
            '\n' +
            '\n' +
            '    <img class="img-sm" src="/assets/user-icon-6122bab3bf45f283f96860b90f4e0846a25f9e68927904222c21e8d2ca26d79f.png">\n' +
            '\n' +
            '  </div>\n' +
            '  <div class="media-body pad-hor ">' +
            '<div class="speech">\n' +
            '      <p class="media-heading">' + data.sender_name + '\n' +
            '        <text class="speech-time">\n' +
            '          <i class="fa fa-clock-o fa-fw"></i>\n' +
            mytime +
            '        </text>\n' +
            '      </p>\n' +
            '      <p style="margin-bottom: 5px; margin-top: 5px;">' + data.body + '</p>\n' +
            '    </div>'

        if (data_ajax["isyourself"]== "1")//就是说是自己发的
          {
            $(".list-unstyled").append(str1);
          }
       else{//不是自己发的
          $(".list-unstyled").append(str2);
        }

      },
      error: function(data){
        alert("没有接收到回信！")
      }

    })


  }
// else{
//         $(".list-unstyled").append(str2);
//     alert("false  the message is not sent by me!");
//   }


});
