import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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

  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Container(
      color: const Color(0xFFEADDFF),
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: WillPopScope(
        onWillPop: () {
      if (_showEmoji) {
        setState(() {
          _showEmoji = !_showEmoji;
        });
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    },
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
                                         return MessageCard(message: _list[index], user: widget.user,);
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
            
                   if(_showEmoji)
                     SizedBox(
                       height: size.height*.35,
                       child: EmojiPicker(
            
                         textEditingController: _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                         config: Config(
                           emojiViewConfig: EmojiViewConfig(
                             backgroundColor: Colors.white,
                             columns: 8,
                             emojiSizeMax: 28 * (Platform.isIOS
                                     ?  1.20
                                     :  1.0),
                           ),
                           searchViewConfig: const SearchViewConfig(
                             backgroundColor: Colors.white
                           ),
                         ),
                       ),
                     )
                   ],
                 ),
            ),
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
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(Icons.emoji_emotions),
                    color: const Color(0xFFB39DDB), // Darker shade of the AppBar color
                  ),

                   Expanded(child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: (){
                     if(_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
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
          //send message button
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
