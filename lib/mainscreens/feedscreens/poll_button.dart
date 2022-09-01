import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:ipoll_application/mainscreens/feedscreens/open_bottom_modal.dart';

import '../../models/question_model.dart';

class PollButtonWidget extends StatelessWidget {
  const PollButtonWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  final int data;

  @override
  Widget build(BuildContext context) {
    final questionModel = Provider.of<QuestionModel>(context);

    List<Color> colorlist = const [
      Color.fromRGBO(196, 223, 170, 1),
      Color.fromRGBO(196, 221, 255, 1),
      Color.fromARGB(255, 255, 247, 180),
      Color.fromARGB(255, 172, 137, 238),
      Color.fromARGB(255, 255, 201, 201)
    ];

    return InkWell(
      splashColor: Colors.yellow,
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          context: context,
          builder: (context) => OpenBottomModal(
            questionId: questionModel.questionid,
            selectedOption: questionModel.options[data],
          ),
        );
      },
      child: Container(
        height: 32,
        width: MediaQuery.of(context).size.width * 0.7,
        constraints: const BoxConstraints(minWidth: 0.4, maxWidth: 0.9),
        margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(230, 239, 250, 1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: Colors.lightBlueAccent.withAlpha(50),
            )),
        child: Text(
          questionModel.options[data],
          style: GoogleFonts.lato(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
