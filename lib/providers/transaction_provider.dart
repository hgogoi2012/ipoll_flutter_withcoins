import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipoll_application/models/trasncation_model.dart';

import '../const/firebase_instance.dart';

class TranscationProvider with ChangeNotifier {
  static List<TransactionModel> _transcationlist = [];

  List<TransactionModel> get getallTransactions {
    return _transcationlist;
  }

  Future<void> fetchTranscations() async {
    String uid = authInstance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('transcations')
        .orderBy(
          'time',
          descending: false,
        )
        .get()
        .then((QuerySnapshot transactionSnapshot) {
      _transcationlist = [];
      for (var element in transactionSnapshot.docs) {
        _transcationlist.insert(
            0,
            TransactionModel(
                transcationid: element.get('referenceId'),
                amount: int.parse(element.get('amount')),
                type: element.get('type'),
                isdebit: element.get('isDebit')));
      }
    });
    // notifyListeners();
  }
}
