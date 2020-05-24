import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _enteredMessage = '';
  var _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(  
              controller: _textController,            
              decoration: InputDecoration(
                labelText: 'New Message',
              ),
              onChanged: (value) {
                // this function will fire with every keyStroke.
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _enteredMessage.isEmpty
                ? null
                : () async {
                  final user = await FirebaseAuth.instance.currentUser();
                  final username = await Firestore.instance.collection('users').document(user.uid).get();
                    Firestore.instance.collection('chat').add(
                      {
                        'text': _enteredMessage,
                        'created': Timestamp.now(),
                        // this is class provided by cloud firestore which give us the time at which the document was created.
                        'userId': user.uid,
                        'username': username['username'],
                        'imageUrl' : username['imageUrl'],
                        // this will store the username also
                      },
                    );
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _textController.clear();
                      // it will clear the feild after sending the message.
                    });
                  },
          ),
        ],
      ),
    );
  }
}
