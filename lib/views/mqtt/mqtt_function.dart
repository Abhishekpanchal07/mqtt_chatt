import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   final client = MqttServerClient('broker.hivemq.com', '1883');
   @override
  void initState() {
    connectmqtt();
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   
    return  Scaffold(
      appBar: AppBar(
        title: customAppbar(),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 50,left: 10,top: 10),
            child: chatfield()
          )
        ],
      ),
    );
  }
  Widget customAppbar(){
    return  SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children:  [
          const Icon(Icons.arrow_back_ios,color: Colors.white,size: 20),
          const SizedBox(
            width: 10,
          ),
          userprofilepic(),
           const SizedBox(
            width: 10,
          ),
          
          const Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Column(
             // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Abhishek Panchal",style: TextStyle(color: Colors.white,fontSize: 16),),
                Text(" connected",style: TextStyle(color: Colors.white,fontSize: 16),)
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget userprofilepic(){
    return Container(
      height: 35,
      width: 35,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white
      ),
    );
  }
  Widget chatfield(){
    return Container(
      color: Colors.red,
     // margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
     // height: 40,
     // width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
              color: Colors.blue,
              width: 2,
            )),
            child: const Row(
              children: [
                Icon(Icons.emoji_emotions,color: Colors.black,),
                Expanded(child: TextField(
                  
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    border: InputBorder.none,
                    hintText: "enter message"
                  ),
                )),
                Icon(Icons.camera_alt,color: Colors.black,)
                ],
      
            )),
           // SizedBox(width: 5,),
           sndMessagebtn()
         
        ],
         
      ),
    );
  }

  Widget sndMessagebtn(){
    return MaterialButton(
     // padding: EdgeInsets.only(right: 20),
      shape: CircleBorder(),
      color: Colors.black,
      onPressed: (){},child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.message,color: Colors.white,),
      ),);
  }

  Future<void>  connectmqtt()async{
final connMess = MqttConnectMessage()
      .withClientIdentifier('dart_client')
      .withWillTopic('willtopic') 
      .withWillMessage('My Will message')
      .startClean() 
      .withWillQos(MqttQos.atLeastOnce);
  print('client connecting....');
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
    print('client connected');
    subscribe();
    publishMessage();
  } else {
    print('client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
   
  }
  return ;
}

void onDisconnected() {
  print('OnDisconnected client callback - Client disconnection');
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    print('OnDisconnected callback is solicited, this is correct');
  }
 
}

/// The successful connect callback
void onConnected() {
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
client.subscribe(topic, MqttQos.atMostOnce);
client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
  final recMess = c![0].payload as MqttPublishMessage;
  final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
  print('Received message: topic is ${c[0].topic}, payload is $pt');
});
}

/// The subscribed callback
void onSubscribed(String topic) {
  print('Subscription confirmed for topic $topic');


}
Future<void> publishMessage() async{
  client.published!.listen((MqttPublishMessage message) {
  print('Published topic: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
});

const pubTopic = 'test/topic';
final builder = MqttClientPayloadBuilder();
builder.addString('Hello from mqtt_client');

print('Subscribing to the $pubTopic topic');
client.subscribe(pubTopic, MqttQos.exactlyOnce);

print('Publishing our topic');
client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);

}
  }
