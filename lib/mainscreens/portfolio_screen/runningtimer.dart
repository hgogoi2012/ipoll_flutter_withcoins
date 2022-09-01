import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';

class RunningTimerWidget extends StatelessWidget {
  const RunningTimerWidget({
    Key? key,
    required this.remainingtime,
  }) : super(key: key);

  final int remainingtime;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return CountdownTimer(
      endTime: remainingtime,
      widgetBuilder: (_, CurrentRemainingTime? time) {
        if (time == null) {
          return Text(
            'Poll Over',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          );
        }
        if (time.days != null) {
          return Text(
            '${time.days} days ${time.hours} hours ${time.min} mins ${time.sec} secs',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.primaryColor,
            ),
          );
        } else if (time.min != null) {
          return Text(
            '${time.min} mins ${time.sec} secs',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.primaryColor,
            ),
          );
        } else {
          final timetext = '${time.sec} secs';
          return Text(
            timetext.replaceAll('null', '0'),
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.primaryColor,
            ),
          );
        }
      },
    );
  }
}
