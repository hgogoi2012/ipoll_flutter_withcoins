import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipoll_application/models/trasncation_model.dart';

import '../const/firebase_instance.dart';
import '../models/ranking_model.dart';

class RanksProvider with ChangeNotifier {
  static List<RankingModel> _alltimeRanklist = [];

  List<RankingModel> get getalltimeRanks {
    return _alltimeRanklist;
  }

  static List<RankingModel> _weeklyRanklist = [];

  List<RankingModel> get getweeklyRank {
    return _weeklyRanklist;
  }

  Timestamp get time {
    return _abv;
  }

  late Timestamp _abv;

  // Timestamp currentTime

  Future<void> fetchAllTimeRanks() async {
    String uid = authInstance.currentUser!.uid;

    final ranks = await FirebaseFirestore.instance
        .collection('ranking')
        .doc('alltime')
        .get();

    _abv = ranks.get('lastupdate');

    Map<String, dynamic> data = ranks.data()!;

    bool isUserPresent = false;
    _alltimeRanklist = [];

    for (int i = 10; i > 0; i--) {
      final Map alltimeranks = data[i.toString()];
      final String image = alltimeranks['image'];
      final String name = alltimeranks['name'];
      final String userUid = alltimeranks['uid'];
      final int points = alltimeranks['point'];
      bool yesPresent = false;

      if (userUid == uid) {
        isUserPresent = true;
        yesPresent = true;
      }

      _alltimeRanklist.insert(
          0,
          RankingModel(
            image: image,
            rank: i.toString(),
            uid: userUid,
            name: name,
            isCurrentUser: yesPresent,
            points: points.toString(),
          ));
    }

    if (!isUserPresent) {
      _alltimeRanklist.removeAt(9);

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userranking')
          .doc(uid)
          .get();

      _alltimeRanklist.add(RankingModel(
          image: userDoc.get('image'),
          rank: '10+',
          uid: uid,
          name: userDoc.get('name'),
          points: userDoc.get('alltime').toString(),
          isCurrentUser: true));
    }

    // notifyListeners();
  }

  Future<void> fetchWeeklyRanks() async {
    String uid = authInstance.currentUser!.uid;

    final ranks = await FirebaseFirestore.instance
        .collection('ranking')
        .doc('weekly')
        .get();

    _abv = ranks.get('lastupdate');

    Map<String, dynamic> data = ranks.data()!;

    bool isUserPresent = false;
    _weeklyRanklist = [];

    for (int i = 10; i > 0; i--) {
      final Map alltimeranks = data[i.toString()];
      final String image = alltimeranks['image'];
      final String name = alltimeranks['name'];
      final String userUid = alltimeranks['uid'];
      final int points = alltimeranks['point'];
      bool yesPresent = false;

      if (userUid == uid) {
        isUserPresent = true;
        yesPresent = true;
      }

      _weeklyRanklist.insert(
          0,
          RankingModel(
            image: image,
            rank: i.toString(),
            uid: userUid,
            name: name,
            isCurrentUser: yesPresent,
            points: points.toString(),
          ));
    }

    print(_alltimeRanklist.length);

    if (!isUserPresent) {
      _weeklyRanklist.removeAt(9);

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('userranking')
          .doc(uid)
          .get();

      _weeklyRanklist.add(RankingModel(
          image: userDoc.get('image'),
          rank: '10+',
          uid: uid,
          name: userDoc.get('name'),
          points: userDoc.get('weekly').toString(),
          isCurrentUser: true));
      // _alltimeRanklist.removeAt(10);
    }

    // notifyListeners();
  }
}
