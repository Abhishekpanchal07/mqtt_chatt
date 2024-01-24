import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/modals/userchatmodal.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ChatController extends GetxController{
  // chat text controller 
  final userchatController = TextEditingController().obs;
// variables for Storing the values 
  var userId = ''.obs;
  var receiveId = ''.obs;
  var isconnected = 'disconnected'.obs;
  var issubscribe = ' not subscribe'.obs;
  var imagePath = ''.obs;
  var showemoji = false.obs;

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
    // Random  random =  Random();
    const deviceId = 'Rohan'; // Replace with a unique identifier for each device
  const clientIdentifier = 'dart_client_$deviceId';
final connMess = MqttConnectMessage()
      .withClientIdentifier(clientIdentifier)
      .withWillTopic('willtopic') 
      .withWillMessage('My Will message')
      .startClean() 
      .withWillQos(MqttQos.atLeastOnce);
  print('client connecting....');
  client.onDisconnected = onDisconnected;
   client.autoReconnect = true;
  client.connectionMessage = connMess;

  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    print('client exception - $e');
    client.disconnect();
  } catch (e) {
    print('socket exception - $e');
    client.disconnect();
  }

  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    isconnected.value = 'client connected';
   print('client connected');
    subscribe();
   // publishMessage("hy muskan");
  } else {
    print('client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
    // client.onDisconnected = onDisconnected;
    // client.onUnsubscribed = onUnsubscribed;
   isconnected.value = 'client disconected';
  }
  return ;
}

void onUnsubscribed(String? topic) {
  print('MQTT_LOGS:: Failed to subscribe $topic');

  print('OnDisconnected client callback - Client disconnection');
  // if (client.connectionStatus!.disconnectionOrigin ==
  //     MqttDisconnectionOrigin.solicited) {
   isconnected.value = 'client disconected';
    print('OnDisconnected callback is solicited, this is correct');
  // }
}

void onDisconnected() {
  issubscribe.value = "Not subscribe";
  print('OnDisconnected client callback - Client disconnection');
  // if (client.connectionStatus!.disconnectionOrigin ==
  //     MqttDisconnectionOrigin.solicited) {
   isconnected.value = 'client disconected';
    print('OnDisconnected callback is solicited, this is correct');
  // }
 
}

/// The successful connect callback
void onConnected() {
   isconnected.value = 'client connected';
  print('OnConnected client callback - Client connection was sucessful');

}

/// Pong callback
void pong() {
  print('Ping response client callback invoked');
}
Future<void> subscribe()async{
  client.onSubscribed = onSubscribed;

const topic = 'topic/test';
print('Subscribing to the $topic topic');
client.subscribe(topic, MqttQos.atLeastOnce);


client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
  final recMess = c![0].payload as MqttPublishMessage;
 
  final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
 final ft = UserChatModal.fromJson(jsonDecode(pt));
 chatDat.add(ft);
 print(ft.message);
 
  print('Received message: topic is ${ft}, payload is $pt');
});
}

/// The subscribed callback
void onSubscribed(String topic) {
  issubscribe.value = "subscribed";
  print('Subscription confirmed for topic $topic');


}
void publishMessage(Map<String,dynamic> usermessage) {
  
 // print(client.connectionStatus?.state.toString() ?? "not connected" );
  
  
  client.published!.listen((MqttPublishMessage message) {
  print('Published topic: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
});
const pubTopic = 'topic/test';
final builder = MqttClientPayloadBuilder();
 final encodedMessage = base64Encode(utf8.encode(usermessage['message'].toString()));
  usermessage['message'] = encodedMessage; // Update the 'message' field with the encoded message
  builder.addString(jsonEncode(usermessage));

print(jsonEncode(usermessage));
userId.value = 'rohan';

print('Subscribing to the $pubTopic topic');

print('Publishing our topic');


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
    imagePath.value = pickedimage.path;
    //Navigator.pop(context);
  }
  else{
    Navigator.pop(context);
  }
}

}