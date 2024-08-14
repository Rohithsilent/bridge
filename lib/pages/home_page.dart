import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          onPressed: (){},
          child:const Icon(Icons.add_comment_rounded),
        ),
      ),
    );
  }
}
