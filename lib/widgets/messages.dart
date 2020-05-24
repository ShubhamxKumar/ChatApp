import 'package:ChatUp/widgets/messBubble.dart';
import 'package:ChatUp/widgets/newMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // futurebuilder is just like the Stream Builder which calls its builder as soon as future resolves
      future: FirebaseAuth.instance.currentUser(),
      // so as soon as we finds out the current user builder will execute
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          builder: (ctx, chatSnapshots) {
            if (chatSnapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              reverse: true,
              // it will display the message from bottom to top, i.e. display the recent messages at the bottom.
              itemBuilder: (context, index) {
                return MessageBubble(
                  message: chatSnapshots.data.documents[index]['text'],
                  isMe: chatSnapshots.data.documents[index]['userId'] == futureSnapshot.data.uid,
                  key: ValueKey(chatSnapshots.data.documents[index].documentID),
                  //.documentID help us to get the unique id of the document
                  // key ensures that whenever flutter rebuilds the UI , it rebuilds it efficiently.
                  username: chatSnapshots.data.documents[index]['username'],
                  imageUrl: chatSnapshots.data.documents[index]['imageUrl'],
                );
              },
              itemCount: chatSnapshots.data.documents.length,
            );
          },
          stream: Firestore.instance
              .collection('chat')
              .orderBy('created', descending: true)
              .snapshots(),
          // this means that the messages will always be ordered by the timestamp feild we created in newMessages.dart, and
          // the newest will be at the bottom.
        );
      },
    );
  }
}
