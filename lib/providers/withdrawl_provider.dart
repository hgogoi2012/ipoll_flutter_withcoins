import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../const/firebase_instance.dart';
import '../models/withdrawl_model.dart';

class WithdrawlProvider with ChangeNotifier {
  static List<WithdrawlModel> _withdrawllist = [];

  List<WithdrawlModel> get getallTransactions {
    return _withdrawllist;
  }

  Future<void> fetchWithdrawl() async {
    String _uid = authInstance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('withdrawls')
        .orderBy('time', descending: false)
        .get()
        .then((QuerySnapshot transactionSnapshot) {
      _withdrawllist = [];
      transactionSnapshot.docs.forEach((element) {
        _withdrawllist.insert(
            0,
            WithdrawlModel(
              withdrawlid: element.get('withdrawlid'),
              amount: int.parse(element.get('amount')),
              isProcessed: element.get('status') == 'pending' ? false : true,
            ));
      });
    });
    // notifyListeners();
  }

  Future<void> requestwithdrawl(
      {required int amount, required BuildContext context}) async {
    try {
      String uid = authInstance.currentUser!.uid;
      String? phone = authInstance.currentUser!.phoneNumber;

      var details = {
        "userId": uid,
        "phone": phone,
        "amount": amount.toString(),
      };

      final response = await http.post(
          Uri.parse(
              'https://asia-south1-ipoll-da231.cloudfunctions.net/ipoll/requestwithdrawl'),
          body: details);

      // final jsonResponse = jsonDecode(response.body);

      // final String tokenData = jsonResponse['cftoken'];
    } catch (e) {}
  }
}
