
import 'package:bridge/models/chat_user.dart';
import 'package:bridge/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../apis/api.dart';
import '../widgets/chat_user_card.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {

  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child:  PopScope(
        // onWillPop: () {
        //   if (_isSearching) {
        //     setState(() {
        //       _isSearching = !_isSearching;
        //     });
        //     return Future.value(false);
        //   } else {
        //     return Future.value(true);
        //   }
        // },

        //if search is on & back button is pressed then close search
        //or else simple close current screen on back button click
        canPop: false,
        onPopInvoked: (_) {
          if (_isSearching) {
            setState(() => _isSearching = !_isSearching);
            return;
          }

          // some delay before pop
          Future.delayed(
              const Duration(milliseconds: 300), SystemNavigator.pop);
        },

        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            leading: Padding(padding: EdgeInsets.only(left:size.height*.01,top:size.height*.01,bottom: size.height*.01 ),
                      child: Image.asset("assets/images/chat.png",)),
            title:_isSearching ? TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                hintText: 'Search for friends...',
                hintStyle: TextStyle(color: Colors.grey[700]),
              ),
             autofocus: true,
              style: TextStyle(fontSize: 17,letterSpacing: 0.5),
              //when searching search list updates
              onChanged: (val){
                  //search logic
                _searchList.clear();

                for(var i in _list){
                  if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase()) ){
                      _searchList.add(i);
                  }
                  setState(() {
                    _searchList;
                  });
                }
              },
            )
                 :Text('Bridge'),

            actions: [
              //icon to search
              IconButton(onPressed: (){
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
                  icon:Icon(_isSearching ?
                      CupertinoIcons.clear_circled_solid
                      :Icons.search) ),
              //more options
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfilePage(user: APIs.me)));
              },
                  icon:const Icon(Icons.person) )
            ],
          ),

          //floating bottom button
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              shape: const CircleBorder(),
              elevation: 0,
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                // await GoogleSignIn().signOut();
              },
              child:const Icon(Icons.add_comment_rounded),
            ),
          ),

          body: StreamBuilder(
            stream: APIs.getAllUsers(),


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
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount:_isSearching ? _searchList.length : _list.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index){
                          return chatUserCard(user:_isSearching ? _searchList[index] : _list[index]);
                        });

                  }
                  else{
                    return const Center(child: Text('No Connection Found!'));
                  }
              }

            },

          ),
        ),
      ),
    );
  }
}
