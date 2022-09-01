import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetService with ChangeNotifier {
  static bool _hasInternet = true;

  bool get internetTracker {
    return _hasInternet;
  }

  Future<void> internetCheck() async {
    InternetConnectionChecker().onStatusChange.listen((status) {
      _hasInternet = status == InternetConnectionStatus.connected;

      notifyListeners();
    });
  }
}
