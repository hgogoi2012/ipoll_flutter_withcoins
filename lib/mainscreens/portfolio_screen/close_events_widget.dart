import 'package:flutter/material.dart';

import 'package:ipoll_application/mainscreens/portfolio_screen/portfolio_result.dart';
import 'package:ipoll_application/services/global_methods.dart';
import 'package:provider/provider.dart';

import '../../models/poll_result_model.dart';
import '../../providers/question_provider.dart';

class ExpiredPageWidget extends StatelessWidget {
  const ExpiredPageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resultModel = Provider.of<PollResultModel>(context);

    final questionsProviders = Provider.of<QuestionProvider>(context);
    final currentQuestions =
        questionsProviders.findPartipcatedQuestionById(resultModel.questionId);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      child: GestureDetector(
        onTap: () {
          GlobalMethods.navigateTo(
              ctx: context, routeName: PortfolioResult.routeName);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ).copyWith(
            bottom: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ).copyWith(bottom: 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 206, 206, 206).withOpacity(0.5),
                  spreadRadius: 3, //spread radius
                  blurRadius: 5, // blur radius
                  offset: const Offset(0, 0), // changes position of shadow
                  //first paramerter of offset is left-right
                  //second parameter is top to down
                ),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(currentQuestions.image!),
                    backgroundColor: Colors.red,
                    radius: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      currentQuestions.question,
                      softWrap: true,
                    ),
                  )
                ],
              ),
              const Divider(
                height: 22,
                thickness: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Investment:     ',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 56, 56, 56),
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: '${resultModel.selectedAmount} coins',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 56, 56, 56),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      text: 'Profit:     ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 56, 56, 56),
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: '100 coins',
                          style: TextStyle(
                            color: Color.fromARGB(255, 56, 56, 56),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
