import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipoll_application/mainscreens/referral_screen/refrerral_widget.dart';
import 'package:ipoll_application/mainscreens/referral_screen/verticaldivider.dart';
import 'package:ipoll_application/services/code_generator.dart';
import 'package:ipoll_application/widgets/background_container.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/user_provider.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  void _showToast(BuildContext context, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied Referral Code'),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
        body: BackgroundContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 19,
          vertical: 25,
        ).copyWith(
          top: 130,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Refer a friend',
              style: GoogleFonts.roboto(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'And you both can earn 30 coins',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const ReferralWidget(
              title: 'Invite your friends',
              subtitle: 'Just share the link and referral code',
              number: 1,
            ),
            const VerticalDividerWidget(),
            const ReferralWidget(
              title: 'Your Friend installs the app',
              subtitle: 'Enter the referral code',
              number: 2,
            ),
            const VerticalDividerWidget(),
            const ReferralWidget(
              title: 'You earn coins',
              subtitle: 'You both earn 30 coins each',
              number: 3,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Referral Link',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 206, 206, 206)
                              .withOpacity(0.5),
                          spreadRadius: 1, //spread radius
                          blurRadius: 5, // blur radius
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ]),
                  child: Text(
                    userProvider.getUser.link.toString(),
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Share.share(
                        'Hi! check out the application and install it using the link ${userProvider.getUser.link} and use my referral code and earn 30 🪙 upon succesfull install',
                        subject: 'Look what I made!');
                  },
                  child: const Icon(
                    Icons.share,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Referral Code',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Text(
                    userProvider.getUser.code.toString(),
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 206, 206, 206)
                              .withOpacity(0.5),
                          spreadRadius: 1, //spread radius
                          blurRadius: 5, // blur radius
                          offset:
                              const Offset(0, 0), // changes position of shadow
                        ),
                      ]),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                      text: userProvider.getUser.code.toString(),
                    ));
                    _showToast(context, theme.primaryColor);
                  },
                  child: const Icon(
                    Icons.copy,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
