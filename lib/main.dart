import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_bin_sense_driver_app/colors.dart';
import 'package:smart_bin_sense_driver_app/views/home_screen.dart';
import 'package:smart_bin_sense_driver_app/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name : "SmartBinSense",
      options: const FirebaseOptions(
    apiKey: "AIzaSyBxvxeQaz9duSs-855uqI4hKAJl7DCe7xk",
    appId: "1:677800212738:android:9341cfbed3a5f1fd666a1b",
    messagingSenderId: "677800212738",
    projectId: "smartbinsense-caa15",
    storageBucket: 'smartbinsense-caa15.appspot.com',
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      home: user != null ? const HomeScreen() : const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: primary, useMaterial3: false),
    );
  }
}
