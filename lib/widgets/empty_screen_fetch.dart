import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class EmptyFetchScreen extends StatelessWidget {
  const EmptyFetchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(230, 239, 250, 1),
      height: double.infinity,
      child: const SpinKitThreeBounce(
        color: Color.fromRGBO(63, 88, 177, 1),
        size: 40,
      ),
    );
  }
}
