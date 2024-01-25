import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/controllers/chat_controllers.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

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
                   // chatcontroller.chatDat[index].message !=null ? chatcontroller.iconpath.value = StringConstants.messageseen: StringConstants.singletick;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                       chatcontroller.chatDat[index].videoPath != null ? 
                       Align(
                        alignment: chatcontroller.chatDat[index].senderId == 1 ? Alignment.topRight : Alignment.topLeft,
                        child: Obx(() => videoContainer(videoUrl:chatcontroller.chatDat[index].videoPath,chatcontroller: chatcontroller ))) :
                        chatcontroller.chatDat[index].imagePath.isNotEmpty 
                       ? Align(
                        alignment: chatcontroller.chatDat[index].senderId == 1 ? Alignment.topRight : Alignment.topLeft,
                        child: imageContainer(imageUrl: chatcontroller.chatDat[index].imagePath))
                       : messageContainer(issend:chatcontroller.chatDat[index].senderId,
                        containerChildText:chatcontroller.chatDat[index].message,
                        containerBgColor: Colors.blueAccent.withOpacity(0.3),),
                       
                        
                       
                        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: chatcontroller.chatDat[index].senderId == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                     getCorrectFormatTime(chatcontroller.chatDat[index].messagetime,context
                     ),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 5,),
            
                    Obx(() => Image.asset(chatcontroller.iconpath.value,height: 12,width: 12,))
                    
              ],
            ),),
            
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
                        // textfield for user chatting
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
                         // Navigator.pop(context);
                          chatcontroller.pickvideo(source: ImageSource.gallery,context);
                        },
                        icon: const Icon(
                          Icons.video_call_outlined,
                          color: Colors.blueAccent,
                        )),
                    IconButton(
                        onPressed: () {
                         // Navigator.pop(context);
                          chatcontroller.pickimage(source: ImageSource.gallery,context);
                        },
                        icon: const Icon(
                          Icons.browse_gallery,
                          color: Colors.blueAccent,
                        )),
                    IconButton(
                        onPressed: () {
                         // Navigator.pop(context);
                         chatcontroller.pickimage(source: ImageSource.camera,context);
                         
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.blueAccent,
                        )),
                  ],
                ),
              ),
            ),

            // send message button
            MaterialButton(
              minWidth: 0,
              shape: const CircleBorder(),
              color: Colors.black,
              onPressed: () {
               chatcontroller.onsendmessagebtntap({
                "senderId":1,
              "receiverId":2,
                "message":chatcontroller.userchatController.value.text,
                "imagePath":"",
                 "videoPath":"",
                "messageTime":DateTime.now().millisecondsSinceEpoch.toString()
              });
                
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
  }

 // for get the sender and receiver time which we will be received from the response
  String getCorrectFormatTime(String readtime,context) {
    final time = DateTime.fromMillisecondsSinceEpoch(int.parse(readtime));
    return TimeOfDay.fromDateTime(time).format(context);
    
  }

   Widget messageContainer(
      {Color? containerBgColor,
      String? containerChildText,
      
      int? issend}) {
    return Align(
      alignment: issend == 1 ? Alignment.topRight : Alignment.topLeft ,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          decoration: BoxDecoration(
            color: containerBgColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(containerChildText!,style: const TextStyle(color: Colors.black,fontSize: 15),),))
                
    );

    } 
    // Image Container
    Widget imageContainer({String? imageUrl}){
      return Container(
      //  alignment: Alignment.topRight,
        height: 250,
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(border: Border.all(
          color: Colors.blueAccent.withOpacity(0.3),
          width: 2
          
        ),
        borderRadius: BorderRadius.circular(13),
        ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          height: 250,
          width: 250,
          fit: BoxFit.cover,
        imageUrl: imageUrl!,
        placeholder: (context, url) => const Center(child:  CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
     ),),
        
      );
    }

     Widget videoContainer({String? videoUrl, ChatController?chatcontroller}){

      chatcontroller!.videocontroller = VideoPlayerController.networkUrl(Uri.parse(
        videoUrl!))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      
      });
      return Container(
      //  alignment: Alignment.topRight,
        height: 250,
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(border: Border.all(
          color: Colors.blueAccent.withOpacity(0.3),
          width: 2
          
        ),
        borderRadius: BorderRadius.circular(13),
        ),
      child: chatcontroller.videocontroller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: chatcontroller.videocontroller.value.aspectRatio,
                  child: VideoPlayer(chatcontroller.videocontroller),
                )
              : Container(),
        
      );
    }

   


  

  
