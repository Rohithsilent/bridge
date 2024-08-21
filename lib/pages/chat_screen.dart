
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../apis/api.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {

  final ChatUser user;
  const ChatScreen({super.key,required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
//for storing messages
   List<Message> _list = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Container(
      color: Color(0xFFEADDFF),
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Color(0xFFEADDFF),
              automaticallyImplyLeading: false,
              flexibleSpace: _appbar(),
            ),
             body: Column(
               children: [
                 Expanded(
                   child: StreamBuilder(
                     stream: APIs.getAllMessages(),
                     builder: (context,snapshot){
                       switch (snapshot.connectionState) {
                       //if data is loading
                         case ConnectionState.waiting:
                         case ConnectionState.none:
                           return const Center(child: CircularProgressIndicator());
                   
                   
                       //if data is loaded
                         case ConnectionState.active:
                         case ConnectionState.done:
                           final data = snapshot.data?.docs;
                           log('Data:${jsonEncode(data![0].data())}');
                           // _list =
                           //     data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                   
                            _list.add(Message(toId: 'xyz',
                                msg: 'hi',
                                read: '',
                                type: Type.text,
                                fromId: APIs.user.uid,
                                sent: '10:00 AM'));
                           _list.add(Message(toId: APIs.user.uid,
                               msg: 'hello',
                               read: '',
                               type: Type.text,
                               fromId: 'anonyms',
                               sent: '13:00 AM'));
                           if (_list.isNotEmpty) {
                             return ListView.builder(
                                   itemCount: _list.length,
                                 physics: const BouncingScrollPhysics(),
                                 padding:EdgeInsets.only(top: size.height*.01),
                                 itemBuilder: (context, index){
                                     return MessageCard(message: _list[index],);
                                 });
                           }
                           else{
                             return const Center(child: Text('Start the conversation!',
                             style: TextStyle(fontSize: 20),));
                           }
                       }
                   
                     },
                   
                   ),
                 ),

                    _chatInput(),
               ],
             ),
        ),
      ),
    );
  }

  Widget _appbar(){
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios_new)),
          ClipRRect(
            borderRadius: BorderRadius.circular(size.height*.3),
            child: CachedNetworkImage(
              width: size.height*.05,
              height: size.height*.05,
              imageUrl: widget.user.image,
              fit: BoxFit.cover,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const CircleAvatar(child: Icon(Icons.person),),
            ),
          ),
          SizedBox(width: 10,),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name, style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500),),
              SizedBox(height: 2,),
              Text('Last seen not available', style: TextStyle(fontSize: 13,color: Colors.black54),),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatInput(){
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height*.01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.emoji_emotions),
                    color: Color(0xFFB39DDB), // Darker shade of the AppBar color
                  ),

                  const Expanded(child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(hintText: 'Chat here...',border: InputBorder.none),
                  )),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.image_rounded),
                    color: Color(0xFFB39DDB), // Darker shade of the AppBar color
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt_rounded),
                    color: Color(0xFFB39DDB), // Darker shade of the AppBar color
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
              minWidth: 40, // Increase minWidth for a larger button
              height: 40, // Set a fixed height for a larger button
              padding: EdgeInsets.only(top: 13,bottom: 13,left: 13,right: 10),
              onPressed: (){},
              shape: CircleBorder(),
              color: Color(0xFF4F378B),
            child: Icon(Icons.send_rounded,color: Colors.white,)
          ),
          SizedBox(width: 4,)
        ],
      ),
    );
  }

}
