
import 'dart:convert';

class UserChatModal {
  UserChatModal({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messagetime,
  });
    int? senderId;
    int? receiverId;
     String ? message;
    String ?messagetime;
  
  UserChatModal.fromJson(Map<String, dynamic> json){
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    message = utf8.decode(base64Decode(json['message']));
    messagetime = json['messageTime'];
  }

  Map<String, dynamic> toJson() {
    final putdata = <String, dynamic>{};
    putdata['senderId'] = senderId;
    putdata['receiverId'] = receiverId;
    putdata['message'] = base64Encode(utf8.encode(message!));
    putdata['messageTime'] = messagetime;
    return putdata;
  }
    
}