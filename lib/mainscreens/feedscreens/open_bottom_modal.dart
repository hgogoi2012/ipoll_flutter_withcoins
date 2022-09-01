import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:ipoll_application/inner_screens/add_money/add_money_screen.dart';
import 'package:ipoll_application/mainscreens/feedscreens/bottomscreenarg.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../inner_screens/success/success_screen.dart';
import '../../providers/question_provider.dart';
import '../../providers/result_provider.dart';
import '../../providers/user_provider.dart';

class OpenBottomModal extends StatefulWidget {
  const OpenBottomModal({
    Key? key,
    required this.questionId,
    required this.selectedOption,
  }) : super(key: key);
  final String questionId;
  final String selectedOption;

  @override
  State<OpenBottomModal> createState() => _OpenBottomModalState();
}

class _OpenBottomModalState extends State<OpenBottomModal> {
  String updatedDropdown = '';
  @override
  final TextEditingController _secondquestion = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  late String? selectedAmount;
  final GroupButtonController _amountcontroller = GroupButtonController();
  bool isSecondOptionSelected = false;
  bool isAmountSelected = false;
  bool isLoading = false;
  bool isFinished = false;
  bool lowbalance = false;

  Future<void> submitPoll() async {
    final questionsProviders =
        Provider.of<QuestionProvider>(context, listen: false);
    final resultProviders = Provider.of<ResultProvider>(context, listen: false);
    final questionbyId = questionsProviders.findQuestionById(widget.questionId);
    String dropdownvalue =
        updatedDropdown.isEmptyOrNull ? widget.selectedOption : updatedDropdown;

    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 0), () {
      try {
        // resultProviders.SubmitPoll(
        //         questionId: widget.questionId,
        //         question: questionbyId.question,
        //         image: questionbyId.image ?? '',
        //         selectedOption: dropdownvalue,
        //         selectedAmount: selectedAmount,
        //         secondOption: _secondquestion.text,
        //         isSecondOption: questionbyId.issecondquestion,
        //         time: questionbyId.remainingTime!,
        //         context: context)
        resultProviders
            .submitPollWallet(
                questionId: widget.questionId,
                question: questionbyId.question,
                image: questionbyId.image ?? '',
                selectedOption: dropdownvalue,
                selectedAmount: selectedAmount,
                secondOption: _secondquestion.text,
                isSecondOption: questionbyId.issecondquestion,
                time: questionbyId.remainingTime!,
                context: context)
            .then((value) {
          setState(() {
            isFinished = false;
          });
        });

        return;
      } catch (e) {
        setState(() {
          isFinished = false;
        });

        return;
      }
    });
    setState(() {
      isFinished = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _secondquestion.dispose();
    _amount.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionsProviders = Provider.of<QuestionProvider>(context);
    final questionbyId = questionsProviders.findQuestionById(widget.questionId);
    final ThemeData theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    Future<int> balance = userProvider.fetchUser().then((value) {
      final userDetails = userProvider.getUser;
      final int amount = userDetails.amount!;
      return amount;
    });

    final secondQuestion = questionbyId.nextquestion.replaceFirst(
        'abc',
        updatedDropdown.isEmptyOrNull
            ? widget.selectedOption
            : updatedDropdown);

    // Initial Selected Value
    String dropdownvalue =
        updatedDropdown.isEmptyOrNull ? widget.selectedOption : updatedDropdown;

    bool isbuttonenabled() {
      if (questionbyId.issecondquestion) {
        if (isAmountSelected == true && isSecondOptionSelected == true) {
          return true;
        }
      } else {
        return isAmountSelected;
      }

      return false;
    }

    return AbsorbPointer(
      absorbing: isLoading,
      child: Wrap(children: [
        Padding(
          padding: const EdgeInsets.only(top: 26.0),
          child: Column(
            children: [
              const Divider(
                height: 2,
                thickness: 5,
                indent: 170,
                endIndent: 170,
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                height: 20,
                thickness: 1,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 40),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    questionbyId.question,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'You Selected',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton(
                      dropdownColor: Colors.white,
                      value: dropdownvalue,
                      items: questionbyId.options
                          .map<DropdownMenuItem<String>>((items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          updatedDropdown = newValue!;
                        });
                      })
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              questionbyId.issecondquestion
                  ? Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 40),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'ESTIMATE CORRECTLY TO WIN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(secondQuestion,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          alignment: Alignment.center,
                          child: GroupButton(
                            isRadio: true,
                            onSelected: (index, isSelected, f) {
                              _secondquestion.text = index.toString();
                              isSecondOptionSelected = true;

                              setState(() {});
                            },
                            buttons: const [
                              "10-20%",
                              "0-20%",
                              "21-30%",
                              "31-40%",
                              "41-50%",
                              "51-60%",
                              "61-70%",
                              "71-80%",
                              "81-90%",
                            ],
                            options: GroupButtonOptions(
                              groupingType: GroupingType.wrap,
                              borderRadius: BorderRadius.circular(15),
                              runSpacing: 00,
                              mainGroupAlignment: MainGroupAlignment.center,
                              spacing: 10,
                              selectedTextStyle: GoogleFonts.roboto(
                                fontSize: 12,
                              ),
                              unselectedTextStyle: GoogleFonts.roboto(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              // direction: Axis.vertical
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  'Voting Amount',
                  style: GoogleFonts.lato(
                    color: Colors.black,
                    // fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final amount = snapshot.data as int;
                    return Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            alignment: Alignment.center,
                            child: GroupButton(
                              controller: _amountcontroller,
                              isRadio: true,
                              onSelected: (index, isSelected, f) {
                                _amount.text = index.toString();
                                selectedAmount =
                                    _amount.text.replaceAll(" coins", "");

                                isAmountSelected =
                                    int.parse(selectedAmount!) < amount
                                        ? true
                                        : false;

                                setState(() {
                                  int.parse(selectedAmount!) > amount
                                      ? lowbalance = true
                                      : lowbalance = false;
                                });
                              },
                              buttons: const [
                                "2 coins",
                                "5 coins",
                                "7 coins",
                                "10 coins",
                              ],
                              options: GroupButtonOptions(
                                groupingType: GroupingType.wrap,
                                borderRadius: BorderRadius.circular(15),
                                selectedColor: theme.primaryColor,

                                runSpacing: 00,
                                mainGroupAlignment: MainGroupAlignment.center,
                                spacing: 10,
                                selectedTextStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: ''),
                                unselectedTextStyle: const TextStyle(
                                    fontSize: 12,
                                    color: black,
                                    fontFamily: '',
                                    fontWeight: FontWeight.bold),
                                // direction: Axis.vertical
                              ),
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ).copyWith(
                            bottom: 5,
                          ),
                          child: SwipeableButtonView(
                            isActive: isbuttonenabled(),
                            buttonText: 'PARTICIPATE',
                            buttonWidget: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.black,
                            ),
                            activeColor: theme.primaryColor,
                            isFinished: isFinished,
                            disableColor: theme.primaryColor.withOpacity(0.5),
                            onWaitingProcess: () {
                              submitPoll();
                            },
                            onFinish: () async {
                              await Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const SuccessScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (lowbalance)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AddMoneyScreen.routeName,
                                  (Route<dynamic> route) => false,
                                  arguments: BottomScreenArguments(
                                    questionid: widget.questionId,
                                    selectedoption: dropdownvalue,
                                    fromBottom: true,
                                  ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                color: theme.primaryColor,
                              ),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Low Balance!',
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '₹ ${amount.toString()}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          'Recharge',
                                          style: GoogleFonts.roboto(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          alignment: Alignment.center,
                          child: GroupButton(
                            controller: _amountcontroller,
                            isRadio: true,
                            onSelected: (index, isSelected, f) {
                              _amount.text = index.toString();
                              selectedAmount =
                                  _amount.text.replaceAll("₹ ", "");

                              setState(() {});
                            },
                            buttons: const [
                              "2 coins",
                              "5 coins",
                              "7 coins",
                              "10 coins",
                            ],
                            options: GroupButtonOptions(
                              groupingType: GroupingType.wrap,
                              borderRadius: BorderRadius.circular(15),
                              selectedColor: theme.primaryColor,

                              runSpacing: 00,
                              mainGroupAlignment: MainGroupAlignment.center,
                              spacing: 10,
                              selectedTextStyle: GoogleFonts.roboto(
                                fontSize: 12,
                              ),
                              unselectedTextStyle: GoogleFonts.roboto(
                                  fontSize: 12, color: black),
                              // direction: Axis.vertical
                            ),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ).copyWith(
                          bottom: 5,
                        ),
                        child: SwipeableButtonView(
                          isActive: isbuttonenabled(),
                          buttonText: 'PARTICIPATE',
                          buttonWidget: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.black,
                          ),
                          activeColor: theme.primaryColor,
                          isFinished: isFinished,
                          disableColor: theme.primaryColor.withOpacity(0.5),
                          onWaitingProcess: () {
                            submitPoll();
                          },
                          onFinish: () async {
                            await Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                child: const SuccessScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                future: balance,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
