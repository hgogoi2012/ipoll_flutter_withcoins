import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:ipoll_application/initialscreens/entermobile_screen.dart';
import 'package:ipoll_application/inner_screens/how_it_works/how_it_works.dart';
import 'package:ipoll_application/inner_screens/widget/backarrow_nav.dart';
import 'package:ipoll_application/mainscreens/feedscreens/widgets/sidebar_list_widget.dart';
import 'package:ipoll_application/mainscreens/leaderboard_screen/leaderBoardScreen.dart';
import 'package:ipoll_application/no_internet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../const/firebase_instance.dart';
import '../../providers/user_provider.dart';
import '../../services/no_internet.dart';
import '../profile_update_screen.dart';
import '../wallet/wallet_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/ProfileScreen';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    ThemeData theme = Theme.of(context);

    final userDetails = userProvider.getUser;

    _showdialog(BuildContext context, String text, bool isHow) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(isHow ? 'How it Works' : 'Note'),
              content: isHow
                  ? Column(
                      children: const [
                        Flexible(
                          child: Text(
                            'iPoll enables you to express your opinion, take stands, showcase support to your favourites by participating in polls designed around everyday happenings, and thereby earn rewards.',
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'iPoll enables you to express your opinion, take stands, showcase support to your favourites by participating in polls designed around everyday happenings, and thereby earn rewards.',
                          ),
                        )
                      ],
                    )
                  : Text(
                      '$text page will be available soon',
                      style: GoogleFonts.lato(),
                    ),
              actions: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            );
          });
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            leading: const BackArrowNav(),
            backgroundColor: theme.primaryColor,
            elevation: 0,
            title: Text(
              'Profile',
              style: GoogleFonts.lato(
                color: theme.focusColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )),
        body: Consumer<InternetService>(builder: (context, model, child) {
          return model.internetTracker
              ? ColoredBox(
                  color: const Color.fromRGBO(230, 239, 250, 1),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 13,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color.fromARGB(255, 206, 206, 206)
                                          .withOpacity(0.5),
                                  spreadRadius: 5, //spread radius
                                  blurRadius: 7, // blur radius
                                  offset: const Offset(0, 2),
                                ),
                              ]),
                          child: Row(
                            children: [
                              ClipOval(
                                  child: SizedBox.fromSize(
                                size: const Size.fromRadius(50),
                                child: CachedNetworkImage(
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    imageUrl: userDetails.image ?? '',
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const SpinKitFoldingCube(
                                          color: Colors.black,
                                        )),
                              )),
                              const SizedBox(
                                width: 17,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userDetails.name ?? 'iPOLL User',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    userDetails.phone ?? '',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  AutoSizeText(
                                    userDetails.email ?? '',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: theme.primaryColor,
                                          minimumSize: Size.zero),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfileUpdateScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Edit Profile',
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w700,
                                          color: theme.focusColor,
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 206, 206, 206)
                                    .withOpacity(0.5),
                                spreadRadius: 5, //spread radius
                                blurRadius: 7, // blur radius
                                offset: const Offset(
                                    0, 2), // changes position of shadow
                                //first paramerter of offset is left-right
                                //second parameter is top to down
                              ),
                            ]),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HowitWorksScreen()),
                                    (Route<dynamic> route) => false);
                              },
                              child: const SidebarListWidget(
                                title: 'How it Works',
                                icon: Icons.info_sharp,
                                isInfo: true,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  WalletScreen.routeName,
                                );
                              },
                              child: const SidebarListWidget(
                                title: 'Wallet',
                                icon: IconlyBold.wallet,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(PageTransition(
                                  child: const LeaderBoardScreen(),
                                  type: PageTransitionType.leftToRight,
                                ));
                              },
                              child: const SidebarListWidget(
                                title: 'Leaderboard',
                                icon: Icons.leaderboard,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showdialog(
                                  context,
                                  'Help Page',
                                  false,
                                );
                              },
                              child: const SidebarListWidget(
                                title: 'Help',
                                icon: Icons.live_help,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showdialog(
                                  context,
                                  'Terms and Conditions',
                                  false,
                                );
                              },
                              child: const SidebarListWidget(
                                title: 'Terms & Conditons',
                                icon: IconlyBold.document,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showdialog(
                                  context,
                                  'Privacy Policy',
                                  false,
                                );
                              },
                              child: const SidebarListWidget(
                                title: 'Privacy Policy',
                                icon: Icons.privacy_tip,
                              ),
                            ),
                            TextButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EnterMobileScreen()),
                                      (Route route) => false);
                                },
                                child: const Text('LOGOUT'))
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const NoInternetPage();
        }));
  }
}
