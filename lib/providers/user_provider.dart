// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'dart:typed_data';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipoll_application/const/firebase_instance.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  static UserModel _userDetail = UserModel(
      name: 'iPOLL User',
      upi: 'abc',
      image:
          'https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?k=20&m=476085198&s=612x612&w=0&h=8J3VgOZab_OiYoIuZfiMIvucFYB8vWYlKnSjKuKeYQM=',
      phone: 'abc',
      amount: 0,
      pan: 'abc',
      email: '');

  UserModel get getUser {
    return _userDetail;
  }

  static bool firstlogin = false;

  bool get getFirstLogin {
    return firstlogin;
  }

  Future<void> skipReferral() async {
    final User? user = authInstance.currentUser;
    String uid = user!.uid;
    firstlogin = true;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'firstlogin': true});
  }

  Future<String> submitReferral(String referralCode) async {
    final User? user = authInstance.currentUser;
    String uid = user!.uid;

    var details = {
      "uid": uid,
      "referCode": referralCode,
    };

    final response = await http.post(
        Uri.parse(
            'https://asia-south1-ipoll-da231.cloudfunctions.net/ipoll/setReferrer'),
        body: details);

    if (response.body == "validrefercode") {
      firstlogin = true;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'firstlogin': true});

      return "success";
    } else if (response.body == "refercodenotvalid") {
      return 'invalidcode';
    } else {
      return 'error';
    }

  }

  Future<void> fetchUser() async {
    final User? user = authInstance.currentUser;
    String uid = user!.uid;

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final DocumentSnapshot walletDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('sec')
        .doc('wallet')
        .get();

    _userDetail = UserModel(
      name: userDoc.get('name'),
      upi: userDoc.get('upiId'),
      image: userDoc.get('profilePicture'),
      phone: userDoc.get('phone'),
      pan: userDoc.get('pancard'),
      amount: walletDoc.get('total'),
      email: userDoc.get('email'),
      promo: walletDoc.get('promo'),
      total: walletDoc.get('total'),
      code: userDoc.get('code'),
      link: userDoc.get('link'),
    );

    firstlogin = userDoc.get('firstlogin');

    notifyListeners();
  }

  Future<String> updatePicture(Uint8List profImage) async {
    try {
      String _uid = authInstance.currentUser!.uid;

      TaskSnapshot upload = await FirebaseStorage.instance
          .ref()
          .child('profilePic')
          .child(_uid)
          .putData(profImage);

      String downloadUrl = await upload.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(_uid).update(
        {'profilePicture': downloadUrl},
      );

      _userDetail.image = downloadUrl;

      notifyListeners();

      return downloadUrl;
    } catch (e) {
      return _userDetail.image!;
    }
  }

  Future<void> updateWallet(
      {required int amount, required BuildContext context}) async {
    final order = DateTime.now().millisecondsSinceEpoch.toString();
    print(amount);

    try {
      String uid = authInstance.currentUser!.uid;

      var details = {
        "uid": uid,
        "order": order,
        "amount": amount.toString(),
      };

      var updateddetails = {
        "uid": uid,
        "amount": amount.toString(),
      };

      final response = await http.post(
          Uri.parse(
            'https://asia-south1-ipoll-da231.cloudfunctions.net/ipoll/payment'),
          body: details);

      final jsonResponse = jsonDecode(response.body);

      Map<String, String> inputParams = {
        "orderId": order,
        "orderAmount": amount.toString(),
        "customerName": 'Himanshu',
        "orderCurrency": 'INR',
        "appId": "1886624990eff538d8589a4871266881",
        "customerPhone": "9954391024",
        "customerEmail": "gogoihimanshu995@gmail.com",
        "stage": "TEST",
        "tokenData": jsonResponse['cftoken']
      };

      await CashfreePGSDK.doUPIPayment(inputParams).then((value) async {
        Map<String, dynamic> transcations = {};
        value?.forEach((key, value) {
          transcations[key] = value;
        });
        if (transcations['txStatus'] == 'SUCCESS') {
          updateddetails['orderId'] = transcations['orderId'].toString();
          updateddetails['referenceId'] =
              transcations['referenceId'].toString();

          await http
              .post(
                  Uri.parse(
                      'https://asia-south1-ipoll-da231.cloudfunctions.net/ipoll/updatewallet'),
                  body: updateddetails)
              .then((value) {});
        }
      });
    } catch (e) {}
  }

  Future<String> updateUserInfo(String title, String? updateText) async {
    try {
      String _uid = authInstance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(_uid).update(
        {title: updateText},
      );

      fetchUser();

      notifyListeners();

      return updateText ?? '';
    } catch (e) {
      return 'something wrong happened';
    }
  }
}
