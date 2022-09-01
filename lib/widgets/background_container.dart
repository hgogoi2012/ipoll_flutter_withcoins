import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(230, 239, 250, 1),
      width: double.infinity,
      height: double.infinity,
      child: child,
    );
  }
}
