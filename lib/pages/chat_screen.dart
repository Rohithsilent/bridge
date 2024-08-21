

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
 //for handling msg text changes
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Container(
      color: const Color(0xFFEADDFF),
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xFFEADDFF),
              automaticallyImplyLeading: false,
              flexibleSpace: _appbar(),
            ),
             body: Column(
               children: [
                 Expanded(
                   child: StreamBuilder(
                     stream: APIs.getAllMessages(widget.user),
                     builder: (context,snapshot){
                       switch (snapshot.connectionState) {
                       //if data is loading
                         case ConnectionState.waiting:
                         case ConnectionState.none:
                           return const SizedBox();

                   
                       //if data is loaded
                         case ConnectionState.active:
                         case ConnectionState.done:
                           final data = snapshot.data?.docs;

                           _list =
                               data?.map((e) => Message.fromJson(e.data())).toList() ?? [];


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
          }, icon: const Icon(Icons.arrow_back_ios_new)),
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
          const SizedBox(width: 10,),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name, style: const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500),),
              const SizedBox(height: 2,),
              const Text('Last seen not available', style: TextStyle(fontSize: 13,color: Colors.black54),),
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
                    icon: const Icon(Icons.emoji_emotions),
                    color: const Color(0xFFB39DDB), // Darker shade of the AppBar color
                  ),

                   Expanded(child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(hintText: 'Chat here...',border: InputBorder.none),
                  )),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image_rounded),
                    color: const Color(0xFFB39DDB), // Darker shade of the AppBar color
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_rounded),
                    color: const Color(0xFFB39DDB), // Darker shade of the AppBar color
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
              onPressed: (){
                if(_textController.text.isNotEmpty){
                  APIs.sendMessage(widget.user, _textController.text);
                  _textController.text = '';
                }
              },
              minWidth: 40, // Increase minWidth for a larger button
              height: 40, // Set a fixed height for a larger button
              padding: const EdgeInsets.only(top: 13,bottom: 13,left: 13,right: 10),
              shape: const CircleBorder(),
              color: const Color(0xFF4F378B),
            child: const Icon(Icons.send_rounded,color: Colors.white,)
          ),
          const SizedBox(width: 4,)
        ],
      ),
    );
  }

}
