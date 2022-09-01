import 'package:flutter/cupertino.dart';

class WithdrawlModel with ChangeNotifier {
  String withdrawlid;
  int amount;
  bool isProcessed;
  WithdrawlModel({
    required this.withdrawlid,
    required this.amount,
    required this.isProcessed,
  });
}
