import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../const/firebase_instance.dart';

Future<void> backgroundHanlder(RemoteMessage message) async {}

class NotificationService {
  static Future<String> initialize() async {
    if (authInstance.currentUser?.uid != null) {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await FirebaseMessaging.instance.getToken();

        // print(token);

        // await FirebaseFirestore.instance.collection("users").doc(uid).update({
        //   'cmg': token,
        // });

        return token!.toString();
      }
    }
    return '';
  }

  static Future<void> readMessage() async {
    FirebaseMessaging.onBackgroundMessage(backgroundHanlder);
    FirebaseMessaging.onMessage.listen((message) {
      print("message received ${message.notification!.title}");
    });
    print('notification initlaize');
  }
}
