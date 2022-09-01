import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ipoll_application/btm_bar.dart';

import 'package:ipoll_application/const/firebase_instance.dart';
import 'package:ipoll_application/fetch_questions.dart';
import 'package:ipoll_application/initialscreens/entermobile_screen.dart';

import 'package:ipoll_application/inner_screens/notification_screen/notification_screen.dart';
import 'package:ipoll_application/mainscreens/feedscreens/feed_screen.dart';

import 'package:ipoll_application/mainscreens/portfolio_screen/portfolio_result.dart';

import 'package:ipoll_application/mainscreens/category_screen/inner_category_screen.dart';
import 'package:ipoll_application/mainscreens/detailed_poll_screen/detailed_poll_screen.dart';
import 'package:ipoll_application/mainscreens/portfolio_screen/portfolio_screen.dart';
import 'package:ipoll_application/mainscreens/referral_screen/referral_screen.dart';

import 'package:ipoll_application/providers/category_provider.dart';
import 'package:ipoll_application/providers/notification_provider.dart';
import 'package:ipoll_application/providers/question_provider.dart';
import 'package:ipoll_application/providers/ranking_provider.dart';
import 'package:ipoll_application/providers/result_provider.dart';
import 'package:ipoll_application/providers/transaction_provider.dart';
import 'package:ipoll_application/providers/user_provider.dart';
import 'package:ipoll_application/providers/withdrawl_provider.dart';
import 'package:ipoll_application/services/code_generator.dart';
import 'package:ipoll_application/services/global_methods.dart';
import 'package:ipoll_application/services/no_internet.dart';
import 'package:ipoll_application/services/notification_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'inner_screens/add_money/add_money_screen.dart';
import 'inner_screens/profile_screen/profile_screen.dart';
import 'inner_screens/wallet/wallet_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await DynamicLinkService.instance?.handleDynamicLinks();

  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  bool hasInternet = true;

  void getInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      if (message.data["page"] == 'email') {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => const PortfolioScreen()));
      }
    }
  }

  @override
  void initState() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;

      setState(() {
        this.hasInternet = hasInternet;
      });
    });

    getInitialMessage();
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: const Text('app ewas opened by notification'),
        duration: Duration(seconds: 10),
        backgroundColor: Colors.green,
      ));
    });

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // GlobalMethods.checkLatestVersion(context);

    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('an error occured'),
              ),
            ),
          );
        }
        return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => QuestionProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CategoryProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => UserProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ResultProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => InternetService(),
              ),
              ChangeNotifierProvider(
                create: (_) => RanksProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => TranscationProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => NotificationProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WithdrawlProvider(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: {
                '/feedscreen': (context) => const FeedScreen(),
                DetailedPollScreen.routeName: (context) =>
                    const DetailedPollScreen(),
                PortfolioResult.routeName: (context) => const PortfolioResult(),
                BottomBarScreen.routeName: (context) => BottomBarScreen(),
                WalletScreen.routeName: (context) => const WalletScreen(),
                ProfileScreen.routeName: (context) => const ProfileScreen(),
                PortfolioScreen.routeName: (context) => const PortfolioScreen(),
                EnterMobileScreen.routeName: (context) =>
                    const EnterMobileScreen(),
                NotificationScreen.routeName: (context) =>
                    const NotificationScreen(),
                AddMoneyScreen.routeName: (context) => const AddMoneyScreen(),
                InnerCategoryScreen.routeName: (context) =>
                    const InnerCategoryScreen(),
              },
              title: 'iPOLL App',
              theme: ThemeData(
                primaryColor: const Color.fromRGBO(63, 88, 177, 1),
                focusColor: Colors.white,
              ),
              // home: OnboardingScreen(),
              // home: ReferralScreen(),
              home: authInstance.currentUser == null
                  ? const EnterMobileScreen()
                  : const FetchQuestions(),
            ));
      },
    );
  }
}
