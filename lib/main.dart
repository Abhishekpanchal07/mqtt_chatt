import 'package:flutter/material.dart';
import 'package:flutter_first_project/views/chat_screen.dart';
import 'package:get/get.dart';

void main() {
  
//   WidgetsFlutterBinding.ensureInitialized();
//  final controller = Get.put(ChatController());
//   controller.connectmqtt().then((value)=> runApp(const MyApp()));
runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

