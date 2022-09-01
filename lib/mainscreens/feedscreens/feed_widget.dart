import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import 'package:ipoll_application/mainscreens/feedscreens/poll_button.dart';
import 'package:ipoll_application/models/question_model.dart';

import 'package:ipoll_application/widgets/timer.dart';
import 'package:ipoll_application/widgets/rounded_rectangle_widget.dart';
import 'package:provider/provider.dart';

import 'open_bottom_modal.dart';

class FeedWidget extends StatelessWidget {
  const FeedWidget({Key? key}) : super(key: key);

  _showOpenDialog(
      BuildContext context, String questionId, String selectedOption) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) => OpenBottomModal(
        questionId: questionId,
        selectedOption: selectedOption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionModel = Provider.of<QuestionModel>(context);

    final DateTime getDateTime = DateTime.parse(questionModel.remainingTime!);
    int abc = getDateTime.millisecondsSinceEpoch + 19800;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 223, 223, 223),
              offset: Offset(1.0, 1.0),
              blurRadius: 5,
              spreadRadius: 2,
              blurStyle: BlurStyle.solid,
            ),
          ],
          borderRadius: BorderRadius.circular(5),
          // border: Border.all(width: 2, color: Colors.black38),
          color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: () {
          _showOpenDialog(
              context, questionModel.questionid, questionModel.options[0]);
          // Navigator.pushNamed(
          //   context,
          //   DetailedPollScreen.routeName,
          //   arguments: questionModel.questionid,
          // );
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundedRectangleWidget(
                    text: questionModel.categories,
                    color: const Color.fromRGBO(63, 88, 177, 1),
                    textColor: Colors.white,
                  ),
                  questionModel.totalParticipants == 0
                      ? Text('No Participants',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700, fontSize: 10))
                      : Text(
                          '${questionModel.totalParticipants} people ',
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                ],
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(
                left: 10,
                top: 10,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: CachedNetworkImage(
                        imageUrl: questionModel.image ??
                            'https://bitsofco.de/content/images/2018/12/broken-1.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SpinKitFoldingCube(
                          color: Colors.black,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        questionModel.question,
                        softWrap: true,
                        style: GoogleFonts.lato(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ]),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DynamicHeightGridView(
                  itemCount: questionModel.options.length,
                  crossAxisCount: 1,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  builder: (context, index) {
                    return PollButtonWidget(data: index);
                  }),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundedRectangleWidget(
                      text: questionModel.issecondquestion
                          ? 'Opinion'
                          : 'Fan Poll',
                      color: questionModel.issecondquestion
                          ? const Color.fromARGB(255, 193, 211, 254)
                          : const Color.fromARGB(255, 255, 229, 217)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        IconlyLight.time_circle,
                        size: 14,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TimerWidget(
                        remainingtime: abc,
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
