import 'dart:convert';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

import '../const/firebase_instance.dart';
import '../inner_screens/success/success_screen.dart';
import '../models/poll_result_model.dart';
import 'package:http/http.dart' as http;

class ResultProvider with ChangeNotifier {
  List<PollResultModel> _pollResultList = [];
  Map<String, double> _resultList = {};

  List<PollResultModel> get getAllParticipatedPoll {
    return _pollResultList;
  }

  Future<void> fetchAllPolls() async {
    String uid = authInstance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('participatedpolls')
        .orderBy('submittedTime', descending: false)
        .get()
        .then((QuerySnapshot pollResultSnapshot) {
      _pollResultList = [];

      for (var element in pollResultSnapshot.docs) {
        _pollResultList.insert(
            0,
            PollResultModel(
              questionId: element.get('questionId'),
              question: element.get('question'),
              image: element.get('image'),
              time: element.get('time'),
              selectedOption: element.get('selectedOption'),
              resultDeclared: element.get('resultDeclared'),
              selectedAmount: element.get('selectedAmount'),
              submittedTime: element.get('submittedTime').toString(),
              secondOptionRequired: element.get('secondOptionRequired'),
              youWon: element.get('youWon'),
              winningAmount: element.get('winningAmount'),
              majority: element.get('majority'),
              isLive: element.get('isLive'),
            ));
        // print(element.get('questionId'));
      }
    });
    notifyListeners();
  }

  // Future<PollResultModel> fetchSinglePolls({required String questionId}) async {
  //   String _uid = authInstance.currentUser!.uid;
  //   String Qid = questionId.trim();
  //   final userPart = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_uid)
  //       .collection('participatedpolls')
  //       .doc(questionId)
  //       .get();

  //   print(Qid);
  //   print(questionId);
  //   final questionPart =
  //       await FirebaseFirestore.instance.collection('questions').doc(Qid).get();

  //   return PollResultModel(
  //     questionId: questionId,
  //     selectedOption: userPart.get('selectedOption'),
  //     resultDeclared: questionPart.get('resultDeclared'),
  //     selectedAmount: userPart.get('selectedAmount'),
  //     submittedTime: userPart.get('submittedTime').toDate(),
  //     secondOptionRequired: questionPart.get('isSecondQuestionreq'),
  //     youWon: userPart.get('youWon'),
  //     winningAmount: userPart.get('winningAmount'),
  //     image: questionPart.get('image'),
  //     questiontitle: questionPart.get('title'),
  //   );
  // }

  // Future<Map<String, dynamic>> generateChartData(
  //     {required String questionId}) async {
  //   final value = await FirebaseFirestore.instance
  //       .collection('questions')
  //       .doc(questionId.trim())
  //       .get();

  //   Map<String, dynamic> data = value.data()!;

  //   final List options = data['option'];

  //   for (int i = 0; i < options.length; i++) {
  //     final pollValue = await FirebaseFirestore.instance
  //         .collection('questions')
  //         .doc(questionId.trim())
  //         .collection('particpants')
  //         .doc(options[i])
  //         .get();

  //     Map<String, dynamic> data = pollValue.data()!;

  //     final finalValue = data['count'];

  //     _resultList[options[i]] = finalValue.toDouble();
  //   }

  //   return _resultList;
  // }

  Future<Map<String, dynamic>> generateChartDatas(
      {required String questionId}) async {
    final value = await FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId.trim())
        .get();

    _resultList = {};

    Map<String, dynamic> data = value.data()!;

    final List options = data['option'];

    for (int i = 0; i < options.length; i++) {
      final pollValue = await FirebaseFirestore.instance
          .collection('questions')
          .doc(questionId.trim())
          .collection('analyticsdata')
          .doc('chart')
          .get();

      Map<String, dynamic> data = pollValue.data()!;

      final finalValue = data[options[i]];

      _resultList[options[i]] = finalValue.toDouble();
    }

    return _resultList;
  }

  Map<String, double> get getChartData {
    return _resultList;
  }

  Future<void> SubmitPoll({
    required String questionId,
    required String question,
    required String image,
    required String selectedOption,
    required var selectedAmount,
    required bool isSecondOption,
    required BuildContext context,
    required String time,
    String? secondOption,
  }) async {
    String _uid = authInstance.currentUser!.uid;
    String? phone = authInstance.currentUser!.phoneNumber;

    final order = DateTime.now().millisecondsSinceEpoch.toString();
    print(selectedAmount.toString().trim());

    try {
      if (_uid.isNotEmpty) {
        var details = {
          "uid": _uid,
          "order": order,
          "amount": selectedAmount.toString(),
        };

        var updateddetails = {
          "uid": _uid,
          "amount": selectedAmount.toString(),
          "questionId": questionId,
          "question": question,
          "image": image,
          "selectedOption": selectedOption,
          "isSecondOption": isSecondOption.toString(),
          "secondOption": isSecondOption ? secondOption : "",
          "time": time
        };

        final response = await http.post(
            Uri.parse(
                'https://asia-south1-ipoll-da231.cloudfunctions.net/ipoll/payment'),
            body: details);

        final jsonResponse = jsonDecode(response.body);

        print(jsonResponse.toString());

        Map<String, String> inputParams = {
          "orderId": order,
          "orderAmount": selectedAmount.toString(),
          "customerName": 'Himanshu',
          "orderCurrency": 'INR',
          "appId": "1886624990eff538d8589a4871266881",
          "customerPhone": phone ?? '+918638487334',
          "customerEmail": "gogoihimanshu995@gmail.com",
          "stage": "TEST",
          "tokenData": jsonResponse['cftoken']
        };

        await CashfreePGSDK.doUPIPayment(inputParams).then((value) async {
          Map<String, dynamic> transcations = {};
          value?.forEach((key, value) {
            transcations[key] = value;
          });
          if (transcations['txStatus'] == 'SUCCESS') {
            updateddetails['orderId'] = transcations['orderId'].toString();
            updateddetails['referenceId'] =
                transcations['referenceId'].toString();
            await http
                .post(
                    Uri.parse(
                        'https://asia-south1-ipoll-da231.cloudfunctions.net/ipoll/updatePoll'),
                    body: updateddetails)
                .then((value) {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: const SuccessScreen()),
              );
            });
          }
        });
      }
    } catch (e) {}

    notifyListeners();
  }

  Future<void> submitPollWallet({
    required String questionId,
    required String question,
    required String image,
    required String selectedOption,
    required var selectedAmount,
    required bool isSecondOption,
    required BuildContext context,
    required String time,
    String? secondOption,
  }) async {
    String uid = authInstance.currentUser!.uid;

    try {
      if (uid.isNotEmpty) {
        var details = {
          "uid": uid,
          "amount": selectedAmount.toString(),
          "questionId": questionId,
          "question": question,
          "image": image,
          "selectedOption": selectedOption,
          "isSecondOption": isSecondOption.toString(),
          "secondOption": isSecondOption ? secondOption : "",
          "time": time
        };

        await http
            .post(
                Uri.parse(
                    'https://asia-south1-ipoll-da231.cloudfunctions.net/ipoll/submitpollv2'),
                body: details)
            .then((value) {
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: const SuccessScreen()),
          );
        });
      }
    } catch (e) {}

    notifyListeners();
  }

  PollResultModel findPollById(String specificId) {
    return _pollResultList.firstWhere(
      (element) => element.questionId.trim() == specificId.trim(),
    );
  }

  List<PollResultModel> get findLivePoll {
    return _pollResultList
        .where(
          (element) => element.isLive == true,
        )
        .toList();
  }

  List<PollResultModel> get findExpiredPoll {
    return _pollResultList
        .where(
          (element) => element.isLive == false,
        )
        .toList();
  }
}
