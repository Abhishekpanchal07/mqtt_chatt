import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/controllers/chat_controllers.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
   final userchatcontroller = TextEditingController();
   final chatcontroller = Get.put(ChatController());
   @override
  void initState() {
    chatcontroller.connectmqtt();
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        onPopInvoked: (didPop) async{
          if(chatcontroller.showemoji.value){
            chatcontroller.isshowemoji(context);
            // ignore: void_checks
            return Future.value(false);
            
          }
          else{
            // ignore: void_checks
             return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Column(
             // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(30),
                    //   child: CachedNetworkImage(
                    //     height: 50,
                    //     width: 50,
                
                    //     imageUrl: "",
                    //     // placeholder: (context, url) => CircularProgressIndicator(),
                    //     errorWidget: (context, url, error) => const CircleAvatar(
                    //       child: Icon(CupertinoIcons.person),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text("Abhishek"),
                  ],
                ),
               // SizedBox(height:10),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  height: 50,
                      width: double.infinity,
                      color: Colors.black,
                      child: Obx(() => Text('${chatcontroller.isconnected.value},${chatcontroller.issubscribe.value}' ,style: const TextStyle(color: Colors.white,fontSize: 14),)),
                    )
              ],
            ),
          ),
          body: Obx(() => Column(
            children: [
              
        
              Expanded(
                child: ListView.builder(
                  itemCount: chatcontroller.chatDat.length,
                  itemBuilder: (context,index){
                    return Column(
                      children: [
                        messageContainer(issend:chatcontroller.chatDat[index].senderId,
                        containerChildText:chatcontroller.chatDat[index].message,
                        containerBgColor: Colors.blueAccent.withOpacity(0.3),),
                       
                        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Align(
              alignment: chatcontroller.chatDat[index].senderId == 2 ? Alignment.topRight : Alignment.topLeft,
              child: Text(
                   getCorrectFormatTime(chatcontroller.chatDat[index].messagetime 
                   ),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
            ),)
                      ],
                    );
                 
                }),
              ),
              userchat(),
             if( chatcontroller.showemoji.value )
        SizedBox(
          height: 300,
          child: EmojiPicker(
             
        textEditingController: chatcontroller.userchatController.value, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: Config(
            columns: 8,
            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
            
            ), // Needs to be const Widget
            
        ),
        ),
        
              
            ],
          ),),
        ),
      ),
    );
  }

  Widget userchat() {
    return Obx(() => 
    SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                         chatcontroller.isshowemoji(context);
                        },
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.blueAccent,
                        )),
                     Expanded(
                        child: TextField(
                      controller: chatcontroller.userchatController.value,
                      onTap: ()  {
                       // FocusScope.of(context).unfocus();
                        if (chatcontroller.showemoji.value) {
                          chatcontroller.isshowemoji(context);
                        }
                        },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                          hintText: "Type something",
                          hintStyle: TextStyle(
                            color: Colors.blueAccent,
                          ),
                          border: InputBorder.none),
                    )),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.browse_gallery,
                          color: Colors.blueAccent,
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.blueAccent,
                        )),
                  ],
                ),
              ),
            ),
            MaterialButton(
              minWidth: 0,
              shape: const CircleBorder(),
              color: Colors.black,
              onPressed: () {
               chatcontroller.onsendmessagebtntap({
  "senderId":2,
  "receiverId":1,
  "message":chatcontroller.userchatController.value.text,
  "messageTime":DateTime.now().millisecondsSinceEpoch.toString()
});
                // if (textfiedcontroller.text.isNotEmpty) {
                //   Apis.sendMessage(widget.userdetail, textfiedcontroller.text);
                //   textfiedcontroller.text = '';
                // }
              },
              child: const Padding(
                padding: EdgeInsets.only(
                    left: 10, top: 10, bottom: 10, right: 5),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

 

// Message container 
Widget greencontainer({String ? receivedMessage}) {
  return Expanded(
    child: Column(
     
      crossAxisAlignment: CrossAxisAlignment.start,
     // mainAxisSize: MainAxisSize.max,
    //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        
        Flexible(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15)),
            child:  Text(
              receivedMessage!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Text(
               getCorrectFormatTime(DateTime.now().millisecondsSinceEpoch.toString()),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
        ),
      ],
    ),
  );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Flexible(
    //       child: Container(
    //         padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
    //         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    //         decoration: BoxDecoration(
    //             color: Colors.blueAccent.withOpacity(0.3),
    //             borderRadius: BorderRadius.circular(15)),
    //         child:  Text(
    //           receivedMessage!,
    //           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    //         ),
    //       ),
    //     ),
    //     const Padding(
    //       padding: EdgeInsets.only(right: 10),
    //       child: Text(
    //         '',
    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    //       ),
    //     )
    //   ],
    // );
  }

  Widget bluecontainer({String ? senderMessage,String?messageTime}) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Column(
       
        crossAxisAlignment: CrossAxisAlignment.end,
       // mainAxisSize: MainAxisSize.max,
      //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15)),
              child:  Text(
                senderMessage!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Text(
                 getCorrectFormatTime(messageTime!),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
          ),
        ],
      ),
    );
  }
  String getCorrectFormatTime(String readtime) {
    final time = DateTime.fromMillisecondsSinceEpoch(int.parse(readtime));
    return TimeOfDay.fromDateTime(time).format(context);
    
  }

   Widget messageContainer(
      {Color? containerBgColor,
      String? containerChildText,
      
      int? issend}) {
    return Align(
      alignment: issend == 2 ? Alignment.topRight : Alignment.topLeft ,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          // height: DimensionConstants.d98.h,
          // width: DimensionConstants.d255.w,
          decoration: BoxDecoration(
            color: containerBgColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(containerChildText!,style: const TextStyle(color: Colors.black,fontSize: 14),),))
                
    );
  }

  }
