import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../const/firebase_instance.dart';
import '../models/question_model.dart';

class QuestionProvider with ChangeNotifier {
  static List<QuestionModel> _questionBank = [];
  static List<QuestionModel> _particpatedquestionBank = [];
  static List<QuestionModel> _selectedUsers = [];

  static List<String> _particpatedPolls = [];
  List<QuestionModel> get getProducts {
    return _questionBank;
  }

  List<QuestionModel> get getParticipatedQuestion {
    return _particpatedquestionBank;
  }

  Future<void> fetchQuestions() async {
    String uid = authInstance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('participatedpolls')
        .get()
        .then((QuerySnapshot allParticpatedpollsSnapshot) {
      _particpatedPolls = [];
      allParticpatedpollsSnapshot.docs.forEach((element) {
        _particpatedPolls.insert(
            0, element.get('questionId').toString().trim());
      });
    });

    await FirebaseFirestore.instance
        .collection('questions')
        .where('showResult', isEqualTo: false)
        // .where('questionid', whereNotIn: _particpatedPolls)
        // .where('CreatedAt', isLessThanOrEqualTo: DateTime.now())
        .orderBy('CreatedAt', descending: false)
        .get()
        .then((QuerySnapshot questionSnapshot) {
      _questionBank = [];
      for (var element in questionSnapshot.docs) {
        _questionBank.insert(
          0,
          QuestionModel(
              questionid: element.get('questionid'),
              question: element.get('title'),
              options: element.get('option'),
              categories: element.get('category'),
              nextquestion: element.get('secondquestion'),
              image: element.get('image') ?? '',
              totalParticipants: element.get('totalparticpants'),
              remainingTime: element.get('expiredDate'),
              issecondquestion: element.get('isSecondQuestionreq')),
        );
        // print(
        //   element.get('questionid'),
        // );
      }
    });
    // notifyListeners();
  }

  Future<void> fetchParticipatedQuestions() async {
    String uid = authInstance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('participatedpolls')
        .orderBy('submittedTime', descending: false)
        .get()
        .then((QuerySnapshot allParticpatedpollsSnapshot) {
      _particpatedPolls = [];
      allParticpatedpollsSnapshot.docs.forEach((element) {
        _particpatedPolls.insert(
            0, element.get('questionId').toString().trim());
      });
    });

    print(_particpatedPolls);
    if (_particpatedPolls.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('questions')
          .where('questionid', whereIn: _particpatedPolls)
          .get()
          .then((QuerySnapshot questionSnapshot) {
        _particpatedquestionBank = [];
        for (var element in questionSnapshot.docs) {
          _particpatedquestionBank.insert(
            0,
            QuestionModel(
                questionid: element.get('questionid'),
                question: element.get('title'),
                options: element.get('option'),
                categories: element.get('category'),
                nextquestion: element.get('secondquestion'),
                totalParticipants: element.get('totalparticpants'),
                image: element.get('image') ?? '',
                remainingTime: element.get('expiredDate'),
                issecondquestion: element.get('isSecondQuestionreq')),
          );
        }
      });

      // _particpatedPolls.removeAt(0);
    }
  }

  // List<QuestionModel> get getOnSaleProducts {
  //   return _questionBank.where((element) => element.categ).toList();
  // }

  QuestionModel findQuestionById(String specificId) {
    return _questionBank.firstWhere(
      (element) => element.questionid.trim() == specificId.trim(),
    );
  }

  QuestionModel findPartipcatedQuestionById(String specificId) {
    return _particpatedquestionBank.firstWhere(
      (element) => element.questionid.trim() == specificId.trim(),
    );
  }

  List<QuestionModel> findByCategory(String categoryName) {
    List<QuestionModel> _categoryList = _questionBank
        .where((element) => element.categories!
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<QuestionModel> fetchUserQuestions() {
    for (int i = 0; i < _particpatedPolls.length; i++) {
      _questionBank
          .removeWhere((element) => element.questionid == _particpatedPolls[i]);
    }

    // _questionBank.removeAt(0);

    return _questionBank;
  }
}

// list3 = list2.where((map)=>list1.contains(map["id"])).toList()