import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/constants/string_constants.dart';
import 'package:flutter_first_project/modals/userchatmodal.dart';
import 'package:flutter_first_project/services/apis.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:video_player/video_player.dart';

class ChatController extends GetxController{
  // chat text controller 
  final userchatController = TextEditingController().obs;
// variables for Storing the values 
  var userId = ''.obs;
  var receiveId = ''.obs;
  var isconnected = 'disconnected'.obs;
  var issubscribe = ' not subscribe'.obs;
  var showemoji = false.obs;
  var isread = false.obs;
  var iconpath = StringConstants.singletick.obs;
  late VideoPlayerController videocontroller;
  
  

   isshowemoji(BuildContext context){
    FocusScope.of(context).unfocus();
    showemoji.value = !showemoji.value;
  }
    

  // mqtt client 
   final client = MqttServerClient('broker.hivemq.com','1883');
   
  // user chat list
  RxList chatDat= <UserChatModal>[].obs;
  
   // chat functions for mqtt 
   Future<void>  connectmqtt()async{
   
    const deviceId = 'Rohan'; // Replace with a unique identifier for each device
  const clientIdentifier = 'dart_client_$deviceId';
final connMess = MqttConnectMessage()
      .withClientIdentifier(clientIdentifier)
      .withWillTopic('willtopic') 
      .withWillMessage('My Will message')
      .startClean() 
      .withWillQos(MqttQos.atLeastOnce);
  log('client connecting....');
  client.onDisconnected = onDisconnected;
   client.autoReconnect = true;
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    log('client exception - $e');
    client.disconnect();
  } catch (e) {
    log('socket exception - $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    isconnected.value = 'client connected';
   log('client connected');
    subscribe();
   // publishMessage("hy muskan");
  } else {
    log('client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    // client.onDisconnected = onDisconnected;
    // client.onUnsubscribed = onUnsubscribed;
   isconnected.value = 'client disconected';
  }
  return ;
}

void onUnsubscribed(String? topic) {
  log('MQTT_LOGS:: Failed to subscribe $topic');

  log('OnDisconnected client callback - Client disconnection');
   isconnected.value = 'client disconected';
    log('OnDisconnected callback is solicited, this is correct');
  
}

void onDisconnected() {
  issubscribe.value = "Not subscribe";
  log('OnDisconnected client callback - Client disconnection');
   isconnected.value = 'client disconected';
    log('OnDisconnected callback is solicited, this is correct');
  
 
}

/// The successful connect callback
void onConnected() {
   isconnected.value = 'client connected';
  log('OnConnected client callback - Client connection was sucessful');

}

/// Pong callback
void pong() {
  log('Ping response client callback invoked');
}
Future<void> subscribe()async{
  client.onSubscribed = onSubscribed;

const topic = 'topic/test';
log('Subscribing to the $topic topic');
client.subscribe(topic, MqttQos.atLeastOnce);


client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
  final recMess = c![0].payload as MqttPublishMessage;
 
  final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
 final ft = UserChatModal.fromJson(jsonDecode(pt));
 chatDat.add(ft);
 log(ft.message.toString());
 
  log('Received message: topic is $ft, payload is $pt');
});
}

/// The subscribed callback
void onSubscribed(String topic) {
  issubscribe.value = "subscribed";
  log('Subscription confirmed for topic $topic');


}
void publishMessage(Map<String,dynamic> usermessage) {
  
 // log(client.connectionStatus?.state.toString() ?? "not connected" );
  
  
  client.published!.listen((MqttPublishMessage message) {
  log('Published topic: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
});
const pubTopic = 'topic/test';
final builder = MqttClientPayloadBuilder();
String? encodedMessage;
encodedMessage = base64Encode(utf8.encode(usermessage['message'].toString()));
  usermessage['message'] = encodedMessage; 
  builder.addString(jsonEncode(usermessage));
log(jsonEncode(usermessage));
log('Subscribing to the $pubTopic topic');
log('Publishing our topic');
  client.publishMessage('topic/test', MqttQos.atLeastOnce, builder.payload!);
  }

void onsendmessagebtntap(Map<String,dynamic> userMessage){

  publishMessage(userMessage) ;
 
  userchatController.value.text = '';
}


// Image Picker 
Future<void> pickimage(BuildContext context,{ImageSource ? source})async{
  final picker = ImagePicker();
  
  final pickedimage = await picker.pickImage(source:source! );
  if(pickedimage!= null){
   
   Apis.uploaduserimage(imageurl: pickedimage.path).then((value) async{
    onsendmessagebtntap({
                "senderId":1,
              "receiverId":2,
                "message":'',
                "imagePath":value.data.url,
                "messageTime":DateTime.now().millisecondsSinceEpoch.toString()
              });
   });
   
            
  }
  else{
   Get.back();
  }
}

// Image Picker 
Future<void> pickvideo(BuildContext context,{ImageSource ? source})async{
  final picker = ImagePicker();
  
  final pickedimage = await picker.pickVideo(source:source!);
  if(pickedimage!= null){
   
   Apis.uploaduserimage(imageurl: pickedimage.path).then((value) async{
    onsendmessagebtntap({
                "senderId":1,
               "receiverId":2,
                "message":'',
                "imagePath":'',
                "videoPath": value.data.url,
                "messageTime":DateTime.now().millisecondsSinceEpoch.toString()
              });
              
   });
   
            
  }
  else{
   Get.back();
  }
}

}




