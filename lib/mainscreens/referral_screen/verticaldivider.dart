import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class VerticalDividerWidget extends StatelessWidget {
  const VerticalDividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 14.0),
      child: const SizedBox(
        height: 20,
        child: VerticalDivider(
          color: Color.fromARGB(255, 95, 95, 95),
          thickness: 1,
        ),
      ),
    );
  }
}
