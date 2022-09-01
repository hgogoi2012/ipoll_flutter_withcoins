// ignore_for_file: unrelated_type_equality_checks

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ipoll_application/inner_screens/profile_screen/profile_screen.dart';
import 'package:ipoll_application/inner_screens/wallet/wallet_screen.dart';

import 'package:ipoll_application/mainscreens/feedscreens/feed_widget.dart';
import 'package:ipoll_application/mainscreens/feedscreens/no_feed_widget.dart';
import 'package:ipoll_application/no_internet.dart';
import 'package:ipoll_application/services/code_generator.dart';
import 'package:ipoll_application/widgets/background_container.dart';
import 'package:ipoll_application/widgets/empty_screen_fetch.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/notification_screen/notification_screen.dart';
import '../../models/question_model.dart';
import '../../providers/question_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/no_internet.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool isFirstLogin = true;
  bool isLoading = false;
  bool inCorrectCode = false;
  StateSetter? _setState;
  TextEditingController referController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Future<List<QuestionModel>> fetchQuestions() async {
    final questionsProviders =
        Provider.of<QuestionProvider>(context, listen: false);
    await questionsProviders.fetchQuestions();

    final List<QuestionModel> fetchquestions =
        questionsProviders.fetchUserQuestions();

    return fetchquestions;
  }

  Future<int> balance() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUser();
    final userDetails = userProvider.getUser;
    final int amount = userDetails.total!;
    return amount;
  }

  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.getFirstLogin == false) {
      DynamicLinkService.checkCode().then((value) {
        value != 'nocode'
            ? referController = TextEditingController(text: value)
            : referController = TextEditingController(text: "");
        WidgetsBinding.instance.addPostFrameCallback(_showOpenDialog(value));
      });
    }

    super.initState();
  }

  onSubmit(String referralCode) async {
    final isValid = _formKey.currentState!.validate();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      _setState!(() {
        isLoading = true;
        inCorrectCode = false;
      });

      final referMessage = await userProvider.submitReferral(referralCode);

      if (referMessage == "success") {
        _setState!(() {
          isLoading = false;
          Navigator.of(context, rootNavigator: true).pop();
        });
        setState(() {});
      } else if (referMessage == "invalidcode") {
        _setState!(() {
          isLoading = false;
          inCorrectCode = true;
        });
        print('fails');
      } else {
        _setState!(() {
          isLoading = false;
        });
      }
    }
  }

  onCancel() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.skipReferral();
  }

  _showOpenDialog(String initalCode) async {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          final ThemeData theme = Theme.of(context);

          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Enter Referral Code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  'Earn 30 coins using a referral code',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                _setState = setState;

                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(
                          top: 0,
                        ),
                        child: TextFormField(
                          controller: referController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Referral Code can\'t be empty';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter Referral Code',
                          ),
                        ),
                      ),
                      if (inCorrectCode)
                        Text(
                          'Incorrect Referral Link.Please try again.',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              onCancel();

                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: theme.primaryColor,
                            ),
                            child: const Text('Skip'),
                          ),
                          TextButton(
                            onPressed: () {
                              onSubmit(referController.text);
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Submit'),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  @override
  void dispose() {
    referController.dispose();
    super.dispose();
  }

  @override
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: theme.primaryColor,
            actions: [
              FutureBuilder(
                future: balance(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitCircle(
                      color: Colors.white,
                      size: 30,
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    final amount = snapshot.data as int;
                    return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              5,
                            )),
                        alignment: Alignment.center,
                        child: Text(amount.toString(),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            )));
                  }
                  return const Text('abc');
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageTransition(
                      child: const WalletScreen(),
                      type: PageTransitionType.bottomToTop,
                    ));
                  },
                  child: Image.asset(
                    'assets/images/coins.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageTransition(
                      child: const NotificationScreen(),
                      type: PageTransitionType.bottomToTop,
                    ));
                  },
                  child: const Icon(
                    Ionicons.ios_notifications_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              )
            ],
            title: RichText(
              text: const TextSpan(
                  text: 'i',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 20,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'POLL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ))
                  ]),
            ),
            centerTitle: true,
            leading: GestureDetector(
              onTap: () async {
                Navigator.of(context).push(PageTransition(
                  child: const ProfileScreen(),
                  type: PageTransitionType.leftToRight,
                ));
              },
              child: Container(
                margin: const EdgeInsets.only(
                  left: 15,
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Ionicons.ios_menu_sharp,
                  color: Colors.black87,
                  size: 17,
                ),
              ),
            )),
        body: BackgroundContainer(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10,
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: fetchQuestions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const EmptyFetchScreen();
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      }

                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        final allQuestions =
                            snapshot.data as List<QuestionModel>;

                        return Consumer<InternetService>(
                            builder: (context, model, child) {
                          return model.internetTracker
                              ? RefreshIndicator(
                                  onRefresh: () {
                                    return Future.delayed(
                                        const Duration(seconds: 1), () {
                                      fetchQuestions();
                                      setState(() {});
                                    });
                                  },
                                  child: allQuestions.isNotEmpty
                                      ? SingleChildScrollView(
                                          child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            DynamicHeightGridView(
                                                itemCount: allQuestions.length,
                                                crossAxisCount: 1,
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                crossAxisSpacing: 20,
                                                mainAxisSpacing: 20,
                                                builder: (context, index) {
                                                  return ChangeNotifierProvider
                                                      .value(
                                                    value: allQuestions[index],
                                                    child: const FeedWidget(),
                                                  );
                                                }),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                          ],
                                        ))
                                      : const NoFeedWidget())
                              : const NoInternetPage();
                        });
                      }
                      return const Text('hello');
                    }),
              ),
            ],
          ),
        ));
  }
}
