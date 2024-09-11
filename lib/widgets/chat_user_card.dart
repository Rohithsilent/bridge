import 'package:bridge/helper/my_date_util.dart';
import 'package:bridge/models/message.dart';
import 'package:bridge/pages/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../apis/api.dart';
import '../models/chat_user.dart';

class chatUserCard extends StatefulWidget {
  final ChatUser user;

  const chatUserCard({super.key,required this.user});

  @override
  State<chatUserCard> createState() => _chatUserCardState();
}

class _chatUserCardState extends State<chatUserCard> {

  Message? _message;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user: widget.user,)));
        },
        child:  StreamBuilder( 
        stream: APIs.getLastMessage(widget.user),
        builder: (context,snapshot){
          final data = snapshot.data?.docs;
          final list =
              data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

          if(list.isNotEmpty){
            _message =list[0];
          }
         return ListTile(

          // leading: const CircleAvatar(child: Icon(Icons.person),),
          leading: ClipRRect(
          borderRadius: BorderRadius.circular(size.height*.3),
            child: CachedNetworkImage(
             width: size.height*.055,
             height: size.height*.055,
             imageUrl: widget.user.image,
              fit: BoxFit.cover,
              // placeholder: (context, url) => CircularProgressIndicator(),
                 errorWidget: (context, url, error) => const CircleAvatar(child: Icon(Icons.person),),
           ),
           ),


           title: Text(widget.user.name),

            subtitle: Text(_message != null ? _message!.msg: widget.user.about,maxLines: 1,),

            // trailing: Text('1:00 PM',style: TextStyle(color: Colors.black54),),
           trailing: _message == null ? null:
               _message!.read.isEmpty && _message!.fromId != APIs.user.uid ?
           Container(
             height: 12,
             width: 12,
             decoration: BoxDecoration(
                 color: Colors.greenAccent.shade400,
                 borderRadius: BorderRadius.circular(7)
    ),
    ) :
                   Text(MyDateUtil.getLastMessageTime(context: context, time: _message!.sent),style: TextStyle(color: Colors.black54),)
    );
      },
      ),
    ),
    );
}}
