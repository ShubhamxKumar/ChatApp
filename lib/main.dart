import 'package:ChatUp/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:ChatUp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(stream: FirebaseAuth.instance.onAuthStateChanged, builder: (ctx, streamSnapshot) {
        // this 'FirebaseAuth.instance.onAuthStateChanged' returns a stream which changes whenever authentication states changes
        // that is wether we are logged in or not.
        if(streamSnapshot.hasData){
          // this means whenever we are logged in correctly FirebaseAuth.instance.onAuthStateChanged will return a stream 
          // which contains user id and token only if we are authenticated properly, else nothing if a error occured.
          return ChatScreen();
        }
        else{
          return AuthScreen();
        }
      },),
    );
  }
}
