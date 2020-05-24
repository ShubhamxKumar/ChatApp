import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final Function pickimage;
  UserImagePicker(this.pickimage);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;

  void _pickImage() async {
    final pickedimage = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 60,
        maxWidth: 200,
        maxHeight: 200);
    setState(() {
      _image = pickedimage;
    });
    widget.pickimage(pickedimage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 50,
          backgroundImage: _image == null
              ? AssetImage('assets/def_image.jfif')
              : FileImage(_image),
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.camera_alt),
          label: Text('Profile Image'),
        ),
      ],
    );
  }
}
