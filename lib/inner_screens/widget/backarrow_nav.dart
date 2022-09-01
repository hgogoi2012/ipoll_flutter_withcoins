import 'package:flutter/material.dart';

import '../../btm_bar.dart';
import '../../mainscreens/feedscreens/bottomscreenarg.dart';

class BackArrowNav extends StatelessWidget {
  const BackArrowNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
        BottomBarScreen.routeName,
        (Route<dynamic> route) => false,
        arguments: BottomScreenArguments(
          questionid: '',
          selectedoption: '',
          fromBottom: false,
        ),
      ),
      // Navigator.of(context).pop(),
      child: Container(
        margin: const EdgeInsets.only(
          left: 15,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //     color:
          //         const Color.fromARGB(255, 206, 206, 206).withOpacity(0.5),
          //     spreadRadius: 3, //spread radius
          //     blurRadius: 5, // blur radius
          //     offset: const Offset(0, 0), // changes position of shadow
          //   ),
          // ]
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_sharp,
          color: Colors.black87,
          size: 16,
        ),
      ),
    );
  }
}
