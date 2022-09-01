import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String? name;
  String? upi;
  List? pollsParticipated;
  int? amountInvested;
  int? amountWon;
  int? total;
  int? promo;
  String? image;
  String? phone;
  String? pan;
  String? email;
  String? link;
  String? code;
  int? amount;
  bool? firstlogin;

  UserModel(
      {this.name,
      this.upi,
      this.pollsParticipated,
      this.amountInvested,
      this.amountWon,
      this.image,
      this.pan,
      this.total,
      this.promo,
      this.link,
      this.code,
      this.amount,
      this.email,
      this.firstlogin,
      this.phone});
}
