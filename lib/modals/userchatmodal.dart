
import 'dart:convert';

class UserChatModal {
  UserChatModal({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messagetime,
    required this.imagePath,
    required this.videoPath
  });
    int? senderId;
    int? receiverId;
     String ? message;
    String ?messagetime;
    String ?imagePath;
    String ?videoPath;
  
  UserChatModal.fromJson(Map<String, dynamic> json){
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    message = utf8.decode(base64Decode(json['message']));
    imagePath = json['imagePath'];
    messagetime = json['messageTime'];
     videoPath = json['videoPath'];
  }

  Map<String, dynamic> toJson() {
    final putdata = <String, dynamic>{};
    putdata['senderId'] = senderId;
    putdata['receiverId'] = receiverId;
    putdata['message'] = base64Encode(utf8.encode(message!));
    putdata['imagePath'] = imagePath;
    putdata['messageTime'] = messagetime;
     putdata['videoPath'] = videoPath;
    return putdata;
  }
    
}