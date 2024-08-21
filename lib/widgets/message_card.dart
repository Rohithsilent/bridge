import 'dart:developer';
import 'package:bridge/helper/my_date_util.dart';
import 'package:flutter/material.dart';
import '../apis/api.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {

  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage() : _purpleMessage();
  }

  //sender or another user message
  Widget _purpleMessage(){
    //update last read message if sender and receiver are different
    if(widget.message.read.isEmpty){
      APIs.updateMessageReadStatus(widget.message);
      log('message read updated');
    }


    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(size.width*.04),
            margin: EdgeInsets.symmetric(horizontal: size.width*.04,vertical: size.height*.01),
            decoration: BoxDecoration(color: const Color.fromARGB(100, 221, 196, 236),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30),bottomRight: Radius.circular(30),topLeft: Radius.circular(30)),
              border: Border.all(color: const Color(0xFF6750A4))
            ),
            child: Text(widget.message.msg,style: const TextStyle(fontSize: 15,color: Colors.black87),),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(right:size.width*.04),

          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13,color: Colors.black54),),
        ),


      ],
    );
  }

//our or user message
  Widget _greenMessage(){
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          children: [
            //adding some space
            SizedBox(width: size.width*.04,),

            //double tick
            if(widget.message.read.isNotEmpty)
            const Icon(Icons.done_all_rounded,color: Colors.blue,size: 20,),
            
            //adding some space
            const SizedBox(width: 2),

            //read time
            Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13,color: Colors.black54),),
          ],
        ),


        Flexible(
          child: Container(
            padding: EdgeInsets.all(size.width*.04),
            margin: EdgeInsets.symmetric(horizontal: size.width*.04,vertical: size.height*.01),
            decoration: BoxDecoration(color: const Color.fromARGB(255, 218, 255, 176),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30),topLeft: Radius.circular(30)),
                border: Border.all(color: Colors.lightGreen)
            ),
            child: Text(widget.message.msg,style: const TextStyle(fontSize: 15,color: Colors.black87),),
          ),
        ),

      ],
    );
  }

}

