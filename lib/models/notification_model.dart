import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class NotificationModel with ChangeNotifier {
  String notificationId;
  String subtitle;
  String type;
  String title;
  Timestamp time;

  NotificationModel(
      {required this.notificationId,
      required this.subtitle,
      required this.type,
      required this.title,
      required this.time});
}
