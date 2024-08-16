import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../apis/api.dart';
import '../widgets/chat_user_card.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title:const Text('Bridge'),
        actions: [
          //icon to search
          IconButton(onPressed: (){},
              icon:const Icon(Icons.search) ),
          //more options
          IconButton(onPressed: (){},
              icon:const Icon(Icons.more_vert) )
        ],
      ),

      //floating bottom button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          elevation: 0,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
          },
          child:const Icon(Icons.add_comment_rounded),
        ),
      ),

      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context,snapshot){
          final list = [];
          if(snapshot.hasData){
            final data = snapshot.data?.docs;
            for(var i in data!){
              log("Data:${i.data()}");
              list.add(i.data()['name']);
            }

          }
          return ListView.builder(
              itemCount: list.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index){
                // return const chatUserCard();
                return Text("Name:${list[index]}");
              });
        },

      ),
    );
  }
}
