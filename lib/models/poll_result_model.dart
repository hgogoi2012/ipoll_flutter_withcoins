import 'package:flutter/cupertino.dart';

class PollResultModel with ChangeNotifier {
  String questionId;
  String question;
  String selectedOption;
  String? secondOption;
  var selectedAmount;
  bool isLive;
  bool resultDeclared;
  bool secondOptionRequired;
  bool? youWon;
  String image;
  String? questiontitle;
  String time;
  String? majority;

  int? winningAmount;
  String submittedTime;
  PollResultModel({
    required this.questionId,
    required this.question,
    required this.selectedOption,
    this.secondOption,
    this.youWon,
    this.winningAmount,
    required this.image,
    this.questiontitle,
    required this.resultDeclared,
    required this.time,
    required this.selectedAmount,
    required this.submittedTime,
    required this.secondOptionRequired,
    required this.majority,
    this.isLive = true,
  });
}
