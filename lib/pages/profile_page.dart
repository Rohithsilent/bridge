
import 'dart:developer';
import 'dart:io';

import 'package:bridge/helper/dialogs.dart';
import 'package:bridge/models/chat_user.dart';
import 'package:bridge/pages/auth/login_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../apis/api.dart';


class ProfilePage extends StatefulWidget {

  final ChatUser user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _formkey = GlobalKey<FormState>();

  String? _image;

  // List<ChatUser> list = [];

  Future<void> deleteAccount(BuildContext context) async {
    // Show confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
          ),
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to Logout your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    // If user confirms deletion, proceed with the delete operation
    if (confirmDelete == true) {
      try {
        dialogs.showProgressBar(context);
        await FirebaseAuth.instance.signOut().then((value) async {
          await GoogleSignIn().signOut().then((value){
            //for removing the progress bar
            Navigator.pop(context);
            //for replacing homepage with login
            Navigator.pop(context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>const loginpage()));
          });
        });
      } catch (error) {
        // Handle any errors that may occur during account deletion
        print("Error deleting account: $error");
        // You can show an error message to the user if needed
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
      
          title:const Text('Profile'),
        ),
      
        //floating bottom button
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            shape: const StadiumBorder(),
            onPressed: () async {
              deleteAccount(context);
              // dialogs.showProgressBar(context);
              // await FirebaseAuth.instance.signOut().then((value) async {
              //   await GoogleSignIn().signOut().then((value){
              //     //for removing the progress bar
              //    Navigator.pop(context);
              //    //for replacing homepage with login
              //    Navigator.pop(context);
              //    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>loginpage()));
              //   });
              // });
            },
            icon:const Icon(Icons.logout,color: Colors.white,),
            label: const Text('Logout',style: TextStyle(color: Colors.white),),
          ),
        ),
      
        body: Form(
          key:_formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: size.width,height: size.height*.03,),
                    
                  Stack(
                    children: [

                      _image != null ?
                      ClipRRect(
                        borderRadius: BorderRadius.circular(size.height*.1),
                        child: Image.file(
                          File(_image!),
                          width: size.height*.2,
                          height: size.height*.2,
                          fit: BoxFit.cover,
                        ),
                      ):
                      ClipRRect(
                        borderRadius: BorderRadius.circular(size.height*.1),
                        child: CachedNetworkImage(
                          width: size.height*.2,
                          height: size.height*.2,
                          fit: BoxFit.cover,
                          imageUrl: widget.user.image,
                          // placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const CircleAvatar(child: Icon(Icons.person),),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: (){
                            _showBottomSheet();
                          },
                          shape:const CircleBorder(),
                          color: Colors.white,
                          child: const Icon(Icons.edit,color: Color(0xFF6750A4),),
                        ),
                      )
                    ],
                  ),
                    
                  SizedBox(height: size.height*.03,),
                    
                  Text(widget.user.email,style: const TextStyle(color: Colors.black54,fontSize: 16),),
                    
                  SizedBox(height: size.height*.05,),
                    
                  TextFormField(
                    onSaved:(val)=> APIs.me.name = val ?? '',
                    validator: (val)=>val !=null && val.isNotEmpty
                        ? null:'Required Field',
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person,color: Color(0xFF6750A4),),
                        label: const Text('Name'),
                        hintText: 'Your name here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                        )),
                    
                  ),
                    
                  SizedBox(height: size.height*.03,),
                    
                  TextFormField(
                    onSaved:(val)=> APIs.me.about = val ?? '',
                    validator: (val)=>val !=null && val.isNotEmpty
                        ? null:'Required Field',
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.info_outline_rounded,color: Color(0xFF6750A4),),
                        label: const Text('About'),
                        hintText: 'Describe yourself',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                        )),
                    
                  ),
                    
                  SizedBox(height: size.height*.05,),
                    
                  ElevatedButton.icon(
                    
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      shape: const StadiumBorder(),
                      minimumSize: Size(size.width*.5, size.height*.06)
                    ),
                      onPressed: (){
                      if(_formkey.currentState!.validate()){
                        _formkey.currentState!.save();
                        APIs.updateUserInfo().then((value){
                          dialogs.showSnackbar(context,'Profile Updated Successfully!');
                        });
                      }
                      },
                      icon: const Icon(Icons.edit,size: 28,),
                      label: const Text('Update',style: TextStyle(fontSize: 16),)
                  )
                    
                    
                    
                ],
              ),
            ),
          ),
        ),
      
      
      ),
    );
  }
void _showBottomSheet(){
  Size size = MediaQuery.of(context).size;
    showModalBottomSheet(context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        builder: (_){
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top:size.height*.03,bottom:size.height*.05),
        children: [
        const  Text('Choose Your Avatar',textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),


         SizedBox(height: size.height*.02,),

         Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
           ElevatedButton(
             style: ElevatedButton.styleFrom(
               shape: const CircleBorder(),
                backgroundColor: Colors.white,
               fixedSize: Size(size.width*.3, size.height*.15)
              ),
               onPressed: () async {
                 final ImagePicker picker = ImagePicker();
                 // Pick an image.
                 final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);

                 if(image !=null){
                   log('Image path:${image.path} -- Mime type:${image.mimeType}');
                   setState(() {
                     _image = image.path;
                   });
                   //to update profile pic
                   APIs.updateProfilePicture(File(_image!));
                   Navigator.pop(context);

                 }

               },
               child: Image.asset('assets/images/picture.png')),

           ElevatedButton(
               style: ElevatedButton.styleFrom(
                   shape: const CircleBorder(),
                   backgroundColor: Colors.white,
                   fixedSize: Size(size.width*.3, size.height*.15)
               ),
               onPressed: () async {
                 final ImagePicker picker = ImagePicker();
                 // Pick an image.
                 final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 80);

                 if(image !=null){
                   log('Image path:${image.path}');
                   setState(() {
                     _image = image.path;
                   });
                  //to update profile pic
                   APIs.updateProfilePicture(File(_image!));

                   Navigator.pop(context);

                 }
               },
               child: Image.asset('assets/images/camera.png')),
  ],)
        ],
      );
    });
}
  
}
