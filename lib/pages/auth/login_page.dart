import 'dart:developer';
import 'dart:io';
import 'package:bridge/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import '../../apis/api.dart';
import '../../helper/dialogs.dart';
import '../../main.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {

  //google signin func
  _handleGoogleBtnClick(){
    dialogs.showProgressBar(context);//for showing progess indicator
     _signInWithGoogle().then((user) async {
       Navigator.pop(context);//for exiting progess indicator/**/
        if(user != null){
          log('\nuser: ${user.user}');
          log('\nAdditionalinfo: ${user.additionalUserInfo}');

          if((await APIs.userExists())){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const homepage()));
          }else{
            await APIs.createUser().then((value) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const homepage()));
            });
          }


        }
     });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    }
    catch(e){
       log('\n_signInWithGoogle:  $e');
       dialogs.showSnackbar(context,'Something Went Wrong (check Internet!)');
       return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // Add a gradient background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFD1DC), // Soft pink
              Color(0xFFFFF8E1), // Pale yellow
              Color(0xFFB3E5FC), // Light blue
              // Color(0xFFE1BEE7), // Light purple
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.08), // 8% of screen height

              Text(
                "Bridge",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.12, // 12% of screen width

                  fontFamily: 'Roboto', // Custom font can be added
                ),
              ),

              SizedBox(height: size.height * 0.01), // 1% of screen height

              Text(
                "Your Conversations, Your Way",
                style: TextStyle(
                  fontSize: size.width * 0.06, // 6% of screen width

                  fontFamily: 'Roboto', // Custom font can be added
                ),
              ),

              SizedBox(height: size.height * 0.05),// 5% of screen height

              SizedBox(
                height: size.height * 0.45, // 40% of screen height
                child: Lottie.asset(
                  'assets/animations/login_animation.json',
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: size.height * 0.1), // 10% of screen height

              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: InkWell(
                  borderRadius: BorderRadius.circular(11),
                  onTap: () {
                    _handleGoogleBtnClick();
                  },
                  child: Container(
                    height: size.height * 0.07, // 7% of screen height
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 7,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/google_logo.png",
                          height: size.height * 0.03, // 3% of screen height
                        ),
                        SizedBox(width: size.width * 0.03), // 3% of screen width
                        Text(
                          "Sign up with Google",
                          style: TextStyle(
                            fontSize: size.width * 0.05, // 5% of screen width
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto', // Custom font can be added
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
