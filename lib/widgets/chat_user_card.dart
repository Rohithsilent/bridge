import 'package:flutter/material.dart';

class chatUserCard extends StatefulWidget {
  const chatUserCard({super.key});

  @override
  State<chatUserCard> createState() => _chatUserCardState();
}

class _chatUserCardState extends State<chatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (){},
        child: const ListTile(
          leading: CircleAvatar(child: Icon(Icons.person),),

          title: Text('Test'),

          subtitle: Text('User message',maxLines: 1,),

          trailing: Text('1:00 PM',style: TextStyle(color: Colors.black54),),
        ),
      ),
    );
  }
}
