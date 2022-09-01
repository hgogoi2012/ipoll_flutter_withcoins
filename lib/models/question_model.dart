import 'package:flutter/material.dart';

class QuestionModel with ChangeNotifier {
  String questionid;
  String question;
  List options;
  String nextquestion;
  String? image;
  String? categories;
  late Map<String, int>? answer;
  List? participants;
  int? totalParticipants;
  String? remainingTime;
  bool issecondquestion;
  bool? resultDeclared;

  QuestionModel({
    required this.questionid,
    required this.question,
    required this.options,
    required this.nextquestion,
    required this.issecondquestion,
    this.image,
    this.categories,
    this.answer,
    this.resultDeclared,
    this.participants,
    this.totalParticipants,
    this.remainingTime,
  });
}
