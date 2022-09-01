import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipoll_application/btm_bar.dart';
import 'package:ipoll_application/mainscreens/portfolio_screen/portfolio_screen.dart';
import 'package:provider/provider.dart';

import '../../models/notification_model.dart';

class NotificationChip extends StatelessWidget {
  const NotificationChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationnModel = Provider.of<NotificationModel>(context);
    DateTime newdate = notificationnModel.time.toDate();
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => BottomBarScreen(
            selectedIndex: 2,
            isClosed: true,
          ),
        ),
        (Route<dynamic> route) => false,
      ),
      child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ).copyWith(
            bottom: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ).copyWith(bottom: 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 206, 206, 206).withOpacity(0.5),
                  spreadRadius: 3, //spread radius
                  blurRadius: 5, // blur radius
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ]),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(
                      5,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: notificationnModel.type == 'YOUWON'
                          ? Colors.white
                          : theme.primaryColor,
                    ),
                    child: notificationnModel.type == 'YOUWON'
                        ? Image.asset(
                            'assets/images/confetti.png',
                            height: 24,
                            width: 24,
                          )
                        : const Icon(
                            Ionicons.notifications,
                            color: Colors.white,
                            size: 16,
                          ),
                  ),
                  const SizedBox(
                    width: 17,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('You won the Poll - ${notificationnModel.title}',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                            )),
                        const SizedBox(
                          height: 7,
                        ),
                        const Text(
                          'Tap to know more',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            GetTimeAgo.parse(newdate),
                            style: GoogleFonts.roboto(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }
}
