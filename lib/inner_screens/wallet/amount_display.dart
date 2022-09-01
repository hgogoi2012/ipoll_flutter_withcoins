import 'package:flutter/material.dart';

import '../../services/utils.dart';

class AmountDisplayWidget extends StatelessWidget {
  const AmountDisplayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenWidth;

    return Stack(
      fit: StackFit.loose,
      children: [
        const SizedBox(
          width: double.infinity,
          height: 120,
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: size,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.yellowAccent,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: size * 0.1,
          child: Container(
              width: size * 0.8,
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.blue),
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow,
                    ),
                    child: const Icon(Icons.wallet),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Your Balance',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Rs 1000',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
