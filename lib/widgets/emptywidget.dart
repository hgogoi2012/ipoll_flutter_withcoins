import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ipoll_application/btm_bar.dart';

import '../mainscreens/feedscreens/feed_screen.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(230, 239, 250, 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 70,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(title,
              style: GoogleFonts.roboto(
                fontSize: 26,
              )),
          const SizedBox(
            height: 20,
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => BottomBarScreen(
                            selectedIndex: 0,
                          )),
                  (Route<dynamic> route) => false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 23,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(63, 88, 177, 1),
                borderRadius: BorderRadius.circular(9),
              ),
              width: 160,
              child: Text(
                'Start Trading',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
