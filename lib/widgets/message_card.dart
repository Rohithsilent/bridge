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
    return Container(
      child: Text(widget.message.msg),
    );
  }

//our or user message
  Widget _greenMessage(){
    return Container();
  }

}

