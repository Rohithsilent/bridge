import 'package:bridge/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../main.dart';


class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;

    return Scaffold(
      //  appBar: AppBar(
      //   centerTitle: true,
      //   elevation: 0,
      //   title:Padding(
      //     padding: const EdgeInsets.only(top:25.0),
      //     child: const Text('Welcome',style: TextStyle(fontSize: 25),),
      //   ),
      //  ),

      body:Column(
        children: [
          SizedBox(height: 30,),
           Text("Bridge",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:35,
            ),),

          SizedBox(height: 7,),
          Text("Your Conversations, Your Way",style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize:23,
          ),),
             SizedBox(height: 30,),
             Lottie.asset('assets/animations/login_animation.json',),
          SizedBox(height: 100,),

            Container(
              width: 320,
              child: InkWell(
                borderRadius: BorderRadius.circular(11),
                onTap: (){

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>const homepage(),
                      ));
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: Colors.black)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(width: 10,),
                      Image.asset("assets/images/google_logo.png", height: 23,),
                      SizedBox(width: 10,),
                      Text(
                        "Sign up with Google", style: TextStyle(fontSize: 20),)
                    ],
                  ),
                ),
              ),
            ),

        ],
      )
    );
  }
}
