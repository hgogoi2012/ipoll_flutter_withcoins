import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    Key? key,
    required this.remainingtime,
    this.fontSize = 10,
    this.color = Colors.black,
  }) : super(key: key);

  final int remainingtime;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      endTime: remainingtime,
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if (time == null) {
          return Text(
            'Poll Over',
            style: GoogleFonts.roboto(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          );
        }
        if (time.days != null) {
          return Text(
            '${time.days} ${time.days == 1 ? 'day' : 'days'}',
            style: GoogleFonts.roboto(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          );
        }

        if (time.hours != null) {
          return Text(
            '${time.hours} ${time.hours == 1 ? 'hour' : 'hours'}',
            style: GoogleFonts.roboto(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          );
        }
        if (time.min != null) {
          return Text(
            '${time.min} ${time.min == 1 ? 'min' : 'mins'}',
            style: GoogleFonts.roboto(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          );
        }
        return Text(
          ' ${time.sec} secs ',
          style: GoogleFonts.roboto(
            color: color,
            fontSize: 12,
          ),
        );
      },
    );
  }
}
