import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:ipoll_application/btm_bar.dart';
import 'package:ipoll_application/inner_screens/add_money/add_money_screen.dart';
import 'package:ipoll_application/inner_screens/request_withdrawl/request_withdrawl.dart';
import 'package:ipoll_application/inner_screens/view_all_transcations/view_all_transcations_screen.dart';

import 'package:ipoll_application/inner_screens/wallet/walletlistwidget.dart';

import 'package:ipoll_application/no_internet.dart';
import 'package:ipoll_application/services/global_methods.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../mainscreens/feedscreens/bottomscreenarg.dart';
import '../../providers/user_provider.dart';
import '../../services/no_internet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);
  static const routeName = '/WalletScreen';

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ThemeData theme = Theme.of(context);
    Future<int> balance = userProvider.fetchUser().then((value) {
      final userDetails = userProvider.getUser;
      final int amount = userDetails.total!;
      return amount;
    });

    _showdialog(BuildContext context, String text, bool isibutton) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(isibutton ? 'Info' : 'Note'),
              content: Text(
                isibutton
                    ? 'Available coins consists of promotional coins and reward coins'
                    : '$text feature will be available soon',
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
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
              BottomBarScreen.routeName,
              (Route<dynamic> route) => false,
              arguments: BottomScreenArguments(
                questionid: '',
                selectedoption: '',
                fromBottom: false,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(
                left: 15,
              ),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.black87,
                size: 16,
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: theme.primaryColor,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            'Wallet',
            style: TextStyle(color: theme.focusColor),
          ),
        ),
        body: Consumer<InternetService>(builder: (context, model, child) {
          return model.internetTracker
              ? Container(
                  height: double.infinity,
                  color: const Color.fromRGBO(230, 239, 250, 1),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // AmountDisplayWidget(),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 30,
                          ),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Available Coins:',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  FutureBuilder(
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            '${snapshot.error} occurred',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        );
                                      } else if (snapshot.hasData) {
                                        final amount = snapshot.data as int;
                                        return Text(
                                          amount.toString(),
                                          style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        );
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                    future: balance,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(
                                      11,
                                    ),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(230, 239, 250, 1),
                                    ),
                                    child: Image.asset(
                                      'assets/images/coins.png',
                                      height: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 9,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showdialog(context, '', true);
                                    },
                                    child: const Icon(
                                      Icons.info,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(
                        //       vertical: 25,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: [
                        //         Container(
                        //           height: 60,
                        //           padding: const EdgeInsets.symmetric(
                        //             horizontal: 15,
                        //             vertical: 10,
                        //           ),
                        //           decoration: BoxDecoration(
                        //             color:
                        //                 const Color.fromRGBO(230, 239, 250, 1),
                        //             borderRadius: BorderRadius.circular(7),
                        //           ),
                        //           child: Row(
                        //             children: [
                        //               GestureDetector(
                        //                 onTap: () {
                        //                   Navigator.pushNamedAndRemoveUntil(
                        //                       context,
                        //                       AddMoneyScreen.routeName,
                        //                       (Route<dynamic> route) => false,
                        //                       arguments: BottomScreenArguments(
                        //                         questionid: '',
                        //                         selectedoption: '',
                        //                         fromBottom: false,
                        //                       ));
                        //                 },
                        //                 child: const Text(
                        //                   'Add Coins',
                        //                   style: TextStyle(
                        //                     fontSize: 16,
                        //                     fontWeight: FontWeight.bold,
                        //                   ),
                        //                 ),
                        //               ),
                        //               const SizedBox(
                        //                 width: 13,
                        //               ),
                        //               Container(
                        //                 padding: const EdgeInsets.all(
                        //                   5,
                        //                 ),
                        //                 decoration: BoxDecoration(
                        //                   shape: BoxShape.circle,
                        //                   color: theme.primaryColor,
                        //                 ),
                        //                 child: const Icon(
                        //                   Icons.add,
                        //                   color: Colors.white,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: const BoxDecoration(
                            color: Colors.white70,
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showdialog(
                                      context, 'Verify your account', false);

                                  // Navigator.of(context).push(PageTransition(
                                  //   child: const VerificationScreen(),
                                  //   type: PageTransitionType.leftToRight,
                                  // ));
                                },
                                child: const WalletListWidget(
                                  title: 'verify your account',
                                  icon: IconlyLight.profile,
                                  isverify: true,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(PageTransition(
                                    child: const ViewAllTranscations(),
                                    type: PageTransitionType.leftToRight,
                                  ));
                                },
                                child: const WalletListWidget(
                                  title: 'view all transcations',
                                  icon: IconlyLight.document,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(PageTransition(
                                    child: BottomBarScreen(
                                      selectedIndex: 3,
                                    ),
                                    type: PageTransitionType.leftToRight,
                                  ));
                                },
                                child: const WalletListWidget(
                                  title: 'refer and earn',
                                  icon: Icons.share,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showdialog(
                                      context, 'Raise a dispute', false);
                                },
                                child: const WalletListWidget(
                                  title: 'Raise a dispute',
                                  icon: Icons.help_center_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                )
              : const NoInternetPage();
        }));
  }
}
