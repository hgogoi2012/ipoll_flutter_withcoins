import 'package:flutter/material.dart';

class ShowSnackBar {
  static snackbar({required content, required context}) {
    final snackbar = SnackBar(
      content: content,
    );

    return ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

