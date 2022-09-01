import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class NoFeedWidget extends StatelessWidget {
  const NoFeedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Ohho! No New Poll remaining ',
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'You have participated in all polls. Don\'t worry we are crafting some interesting polls for you. Please check back again later',
            style: GoogleFonts.roboto(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
