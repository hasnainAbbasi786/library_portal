import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_portal/screens/main_Screen.dart';
import 'package:library_portal/screens/registration/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color(0xff213E94)
          //color set to purple or set your own color
        ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library Portal',
      theme: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: const Color(0xff213E94)
        )
      ),
      home:  LoginScreen()
    );
  }
}


