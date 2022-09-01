import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ipoll_application/mainscreens/portfolio_screen/portfolio_result.dart';
import 'package:provider/provider.dart';

import '../../models/poll_result_model.dart';

class LivePageWidget extends StatelessWidget {
  const LivePageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resultModel = Provider.of<PollResultModel>(context);

    // final questionsProviders = Provider.of<QuestionProvider>(context);
    // final currentQuestions =
    //     questionsProviders.findPartipcatedQuestionById(resultModel.questionId);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            PortfolioResult.routeName,
            arguments: resultModel.questionId,
          );
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
                  ClipOval(
                      child: SizedBox.fromSize(
                    size: const Size.fromRadius(30),
                    child: CachedNetworkImage(
                        imageUrl: resultModel.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SpinKitFoldingCube(
                              color: Colors.black,
                            )),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Text(
                      resultModel.question,
                      softWrap: true,
                      style: GoogleFonts.roboto(),
                    ),
                  )
                ],
              ),
              const Divider(
                height: 22,
                thickness: 3,
              ),
              Row(
                mainAxisAlignment: resultModel.isLive
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceAround,
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
                  resultModel.isLive
                      ? const SizedBox()
                      : RichText(
                          text: TextSpan(
                            text: 'Returns:     ',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 56, 56, 56),
                              fontWeight: FontWeight.w700,
                            ),
                            children: [
                              TextSpan(
                                text: '${resultModel.winningAmount} coins',
                                style: const TextStyle(
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
