import 'dart:io';

import 'package:ChatUp/widgets/userImagePicker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function submit;
  final bool _isLoading;
  AuthForm(this.submit, this._isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _isLogin = true;
  String _email = '';
  String _username = '';
  String _password = '';
  File _image;
  void pickImage(File pickedimage) {
    _image = pickedimage;
  }

  void _saveData() {
    FocusScope.of(context)
        .unfocus(); //it will close the soft keyboard on tapping the log in button
    if (_image == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'Please choose a image, don\'t worry you can change it later')));
              return;
    }
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      // this will call onSaved on each TextFormFeild
      widget.submit(_email.trim(), _username.trim(), _password.trim(), _isLogin,
          _image, context);
      // .trim() is used to eliminate any white spces before or after the string we passed.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.green[400],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _isLogin
                      ? SizedBox(
                          height: 0,
                        )
                      : UserImagePicker(pickImage),
                  TextFormField(
                    initialValue: _email,
                    key: ValueKey('email'),
                    // every field should have a unique key so that the values do not jump when we switch screens.
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty ||
                          !value.contains('@') ||
                          !value.contains('.com')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                  _isLogin
                      ? SizedBox(
                          height: 0,
                        )
                      : TextFormField(
                          key: ValueKey('username'),
                          decoration: InputDecoration(
                            labelText: 'Username',
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.length < 4) {
                              return 'Please enter a username with more than 4 charachter.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _username = value;
                          },
                        ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(
                      labelText: 'password',
                    ),
                    obscureText: true,
                    // it will hide the password.
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Please enter a password with more than 7 charachters.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                  ),
                  widget._isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          onPressed: _saveData,
                          child: Text(_isLogin ? 'Log In' : 'Sign Up'),
                        ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? 'Create a new account'
                        : 'Already have an account? Login In'),
                  ),
                ],
              ),
            ),
            padding: EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }
}
