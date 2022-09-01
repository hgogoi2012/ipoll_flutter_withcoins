import 'package:flutter/material.dart';

class ResultRowWidget extends StatelessWidget {
  const ResultRowWidget({
    Key? key,
    required this.title,
    required this.data,
    this.isWon = false,
  }) : super(key: key);
  final String title;
  final String data;
  final bool isWon;

  _showdialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('How it Works'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                    'If your choosen option gets X% of votes (say, 53%), you get 53 coins.'),
                SizedBox(
                  height: 10,
                ),
                Text(
                    ' If your choosen option is the one preferred by majority, then you also gets 2Y coins (Y is the option you voted with)'),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'So you win:  X+2(Y) coins , Y is applicable only when your chosen option is also the one preferred by majority.'),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            actions: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 18,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            data,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          !isWon
              ? GestureDetector(
                  onTap: () {
                    _showdialog(context);
                  },
                  child: const Icon(
                    Icons.info,
                    size: 18,
                    color: Colors.black87,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
