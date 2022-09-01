import 'package:flutter/cupertino.dart';

class TransactionModel with ChangeNotifier {
  String transcationid;
  int amount;
  String type;
  bool isdebit;
  TransactionModel({
    required this.transcationid,
    required this.amount,
    required this.type,
    required this.isdebit,
  });
}
