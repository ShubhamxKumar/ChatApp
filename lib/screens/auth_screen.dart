import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ChatUp/widgets/authForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth
      .instance; // this will give us a instance of firebase auth object, which automatically setup
  // and managed by firebase when we did the setup
  AuthResult _authResult;
  // an object of type AuthResult which will hold the future returned after login or signup. 
  // it contains id and other important features.
  void _submitAuthForm(
    String email,
    String username,
    String password,
    bool isLogin,
    File image,
    BuildContext ctx,
  ) async {
    try{
      if (isLogin) {
        setState(() {
          _isLoading = true;
        });
      _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
          print(_authResult.user.uid);
        setState(() {
          _isLoading = false;
        });  
    }
    else{
      setState(() {
          _isLoading = true;
        });
      _authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      final ref = FirebaseStorage.instance.ref().child('userProfile').child(_authResult.user.uid + '.jpg');

      // Now here 'FirebaseStorage.instance.ref()' this code points at the root bucket of our cloud storage.
      // the .child after creates a folder of name 'userProfile'
      // and the child after will create a file which will contain the profile pic of that user.
      // we are using user id as a name for the image so that every image has a unique name
      // the whole snippet returns a StorageReference which we store in a variable and then use it to upload image.

      await ref.putFile(image).onComplete;
      // this will put the file or upload the file to that folder with that name.
      // the .onComplete will return a future to which we can await. 

      var url = await ref.getDownloadURL();
      // this will get the download url of the image, which we can upload to the 
      await Firestore.instance.collection('users').document(_authResult.user.uid).setData({
        'username' : username,
        'email' : email,
        'imageUrl' : url,
      });
      //  .add method also created a document but with a Firebase automatically generated id .
      setState(() {
          _isLoading = false;
        });
    }
    } on PlatformException catch(err){ // 'on' keyword helps us to catch specific type of errors, like in this case errors like 
    // invalid password or invalid email etc.
    var message = "Some error occured.";
    if(err.message!=null){
      // if the err message we get is not empty then
      print(err.message);
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(err.message),
      ));
    }

    } catch(err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
