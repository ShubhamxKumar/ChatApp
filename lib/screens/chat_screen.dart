import 'package:ChatUp/widgets/messages.dart';
import 'package:ChatUp/widgets/newMessage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatScreen'),
        actions: <Widget>[
          DropdownButton(
            items: [
              DropdownMenuItem(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.blueAccent,
                    ),
                    Text('LogOut'),
                  ],
                ),
                value: 'logout',
              )
            ],
            // on changed takes a argument which is the 'value' parameter of the DropDownMenuItem
            onChanged: (whatwaspressed) {
              if (whatwaspressed == 'logout') {
                FirebaseAuth.instance.signOut();
                // this will log the user out. This will automatically destroy the user token, and also changes the stream
                // which we use in main.dart.
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          )
        ],
      ),
      // Stream builder takes two arguments, stream and builder.
      // stream argument wants a stream which is returned by 'Firebase.instance.collection('path').snapshots()'.
      // and builder takes a function with context and a stream, so that that the builder automatically calls the function
      // whenever the stream gives us new data.
      // the snapshots in Firebase command automatically listen to the changes in the UI and alert whenever the
      // database is updated.
      body: Column(
        children: <Widget>[
          Expanded(child: Messages()),
          NewMessage(),
        ],
      ),
      backgroundColor: Colors.white,
      /* floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            /* Firestore.instance
                .collection('/chats/L4JAWgdsX3gbDRT1pN9A/messages')
                .add({
              'text': 'This was added after clicking the button',
              // this way we add a new document to the collection with feild 'text'.
            }); */
          }), */
    );
  }
}
