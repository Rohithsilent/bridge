import 'dart:developer';
import 'dart:io';
import 'package:bridge/models/chat_user.dart';
import 'package:bridge/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs{
  //firebase auth
  static FirebaseAuth auth = FirebaseAuth.instance;

  //firestore database object
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //current user
  static User get user => auth.currentUser!;

  //storing self info
  static late ChatUser me;

  //for checking if user exists or not
  static Future<bool> userExists()async{
    return (await firestore
        .collection('users')
        .doc(user.uid)
        .get()).exists;
  }


  static Future<void> getSelfInfo()async{
     await firestore
        .collection('users')
        .doc(user.uid)
        .get().then((user) async {
         if(user.exists){
           me = ChatUser.fromJson(user.data()!);
           log('MY DATA:${user.data()}');
         }else{
           await createUser().then((value)=>getSelfInfo());
         }
     });
  }

  //creating new user
  static Future<void> createUser()async{
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Connected on Bridge! Let's chat!",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
       );

    return await firestore
        .collection('users')
        .doc(user.uid).set(chatUser.toJson());
  }


  //for getting users for firebase firestore
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return firestore.collection('users')
        .where('id',isNotEqualTo: user.uid)
        .snapshots();
  }

  //for updating user info
  static Future<void> updateUserInfo()async{
   await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name':me.name,'about':me.about});
  }

  static Future<void> updateProfilePicture(File file) async{
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension:$ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0){
      log('Data Transferred:${p0.bytesTransferred/1000} kb');
    });

    //updating image in firestore database
   me.image =await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image':me.image});
  }

  ///------------------------Chat Screen APIs-----------------------------------------


  //for getting conversation id
  static String getConversationID(String id)=>user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //for getting messages of a conversation in firebase firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user){
    return firestore.collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  //gor sending message
  static Future<void> sendMessage(ChatUser chatUser,String msg) async{
    //message sending time (also used ad id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
     //message to send
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: Type.text,
        fromId: user.uid,
        sent: time);

    final ref = firestore.collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }


  static Future<void> updateMessageReadStatus(Message message) async{
    firestore.collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
    
  }
}



