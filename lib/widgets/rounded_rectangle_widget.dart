import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class RoundedRectangleWidget extends StatelessWidget {
  const RoundedRectangleWidget(
      {Key? key,
      required this.text,
      required this.color,
      this.textColor = Colors.black})
      : super(key: key);

  final String? text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text ?? '',
        style: GoogleFonts.roboto(
            fontWeight: FontWeight.w600, fontSize: 10, color: textColor),
      ),
    );
  }
}
