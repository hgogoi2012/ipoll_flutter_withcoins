import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:ipoll_application/widgets/background_container.dart';
import 'package:ipoll_application/widgets/rounded_rectangle_widget.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/widget/backarrow_nav.dart';
import '../../providers/question_provider.dart';
import '../../services/utils.dart';
import '../feedscreens/open_bottom_modal.dart';

class DetailedPollScreen extends StatefulWidget {
  const DetailedPollScreen({Key? key}) : super(key: key);
  static const routeName = '/DetailedPollScreen';

  @override
  State<DetailedPollScreen> createState() => _DetailedPollScreenState();
}

class _DetailedPollScreenState extends State<DetailedPollScreen> {
  String updatedValue = '';
  bool isValueSelected = false;
  final formGlobalKey = GlobalKey<FormState>();
  var firstquestionController = GroupButtonController();

  @override
  void dispose() {
    firstquestionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    final questionsProviders = Provider.of<QuestionProvider>(context);
    final currentQuestions = questionsProviders.findQuestionById(catName);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
            leading: const BackArrowNav(),
            backgroundColor: theme.primaryColor,
            elevation: 0,
            title: Text(
              'Poll Details',
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )),
        body: BackgroundContainer(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Form(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RoundedRectangleWidget(
                          text: currentQuestions.categories!,
                          color: Colors.amberAccent,
                        ),
                        Text(
                          currentQuestions.participants == null
                              ? 'No Participants'
                              : currentQuestions.totalParticipants.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 40),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        currentQuestions.question,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      alignment: Alignment.center,
                      child: GroupButton(
                        controller: firstquestionController,
                        isRadio: true,
                        onSelected: (index, isSelected, f) {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (context) => OpenBottomModal(
                              questionId: currentQuestions.questionid,
                              selectedOption:
                                  currentQuestions.options[isSelected],
                            ),
                          );
                        },
                        buttons: currentQuestions.options,
                        options: GroupButtonOptions(
                          groupingType: GroupingType.wrap,
                          borderRadius: BorderRadius.circular(15),
                          runSpacing: 00,
                          mainGroupAlignment: MainGroupAlignment.center,
                          spacing: 10,
                          selectedTextStyle: const TextStyle(fontSize: 15),
                          unselectedTextStyle: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('MORE DESCRIPTION ABOUT THE POLL ')
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
