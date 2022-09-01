import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 27,
        vertical: 5,
      ),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(
            5,
          )),
      child: Text(
        'Title',
        style: TextStyle(
          color: Colors.white,
          fontSize: 19,
        ),
      ),
    );
  }
}
