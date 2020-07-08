import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  static getUsername(String email) {
    return "Id:${email.split("@")[0]}";
  }

  static getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    return (nameSplit[0][0] + nameSplit[1][0]).toUpperCase();
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    final _picker = ImagePicker();
    PickedFile pickedImage = await _picker.getImage(
        source: source, imageQuality: 60, maxHeight: 1000, maxWidth: 1000);
    File selectedImage = File(pickedImage.path);
    return selectedImage;
  }
}
