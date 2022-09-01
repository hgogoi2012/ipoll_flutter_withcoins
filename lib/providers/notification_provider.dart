import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../const/firebase_instance.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  static List<NotificationModel> _notificationlist = [];

  List<NotificationModel> get getallNotifications {
    return _notificationlist;
  }

  Future<void> fetchNotifications() async {
    String _uid = authInstance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('notifications')
        .orderBy('timestamp', descending: false)
        .get()
        .then((QuerySnapshot notificationSnapshot) {
      _notificationlist = [];
      notificationSnapshot.docs.forEach((element) {
        _notificationlist.insert(
            0,
            NotificationModel(
                notificationId: element.get('notificationId'),
                subtitle: 'Result',
                type: element.get('type'),
                title: element.get('title'),
                time: element.get('timestamp')));
      });
    });
    // notifyListeners();
  }
}
