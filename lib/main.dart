import 'package:bridge/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

late Size size;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //for setting orientation
  await _initializeFirebase();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((value){
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bridge',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 1,
        )
      ),
      home:const SplashScreen(),
    );
  }
}



_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

