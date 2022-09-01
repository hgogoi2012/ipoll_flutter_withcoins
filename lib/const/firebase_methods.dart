import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ipoll_application/const/firebase_instance.dart';

class FirebaseMethods {
  static Future uploadImage(Uint8List profImage) async {
    try {
      String _uid = authInstance.currentUser!.uid;

      TaskSnapshot upload = await FirebaseStorage.instance
          .ref()
          .child('profilePic')
          .child(_uid)
          .putData(profImage);

      String downloadUrl = await upload.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .update({'profilePicture': downloadUrl});
    } catch (e) {}
  }
}
