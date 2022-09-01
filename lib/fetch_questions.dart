import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipoll_application/btm_bar.dart';
import 'package:ipoll_application/providers/category_provider.dart';
import 'package:ipoll_application/providers/question_provider.dart';
import 'package:ipoll_application/providers/user_provider.dart';
import 'package:ipoll_application/services/no_internet.dart';
import 'package:provider/provider.dart';

import 'providers/result_provider.dart';

class FetchQuestions extends StatefulWidget {
  const FetchQuestions({Key? key}) : super(key: key);

  @override
  State<FetchQuestions> createState() => _FetchQuestionsState();
}

class _FetchQuestionsState extends State<FetchQuestions> {
  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 5), () async {
      final questionProvider =
          Provider.of<QuestionProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final resultProvider =
          Provider.of<ResultProvider>(context, listen: false);
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final internetProvider =
          Provider.of<InternetService>(context, listen: false);

      await internetProvider.internetCheck();
      await categoryProvider.fetchCategories();
      await questionProvider.fetchQuestions();
      await userProvider.fetchUser();
      await resultProvider.fetchAllPolls();

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => BottomBarScreen(),
      ));
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(230, 239, 250, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitCircle(
              color: theme.primaryColor,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              'iPOLL',
              style: GoogleFonts.syne(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
