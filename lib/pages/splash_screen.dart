import 'dart:developer';
import 'package:bridge/pages/auth/login_page.dart';
import 'package:bridge/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../apis/api.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white));
     if(APIs.auth.currentUser !=null){
       log('\nUser: ${APIs.auth.currentUser}');
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const homepage()));
     }
     else{
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const loginpage()));
     }
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or Image
            Image.asset(
              "assets/images/chat.png",
              height: size.height * 0.2, // Adjust to 20% of screen height
              width: size.width * 0.4, // Adjust to 40% of screen width
              fit: BoxFit.contain,
            ),
            SizedBox(height: size.height * 0.05), // 5% of screen height

            // Linear Progress Indicator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1), // 10% of screen width
              child: Container(
                height: size.height * 0.005, // Adjust height of the progress bar
                decoration: BoxDecoration(
                  color: Colors.blueAccent, // Background color of the progress bar
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                child: const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.transparent, // Make the background transparent
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
