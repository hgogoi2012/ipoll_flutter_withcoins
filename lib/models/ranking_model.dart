import 'package:flutter/material.dart';

class RankingModel with ChangeNotifier {
  String image;
  String rank;
  String uid;
  String name;
  String points;
  bool isCurrentUser;
  RankingModel({
    required this.image,
    required this.rank,
    required this.uid,
    required this.name,
    required this.points,
    required this.isCurrentUser,
  });
}
