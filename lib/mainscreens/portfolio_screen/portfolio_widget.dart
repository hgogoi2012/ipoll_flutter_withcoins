import 'package:flutter/material.dart';

import 'package:ipoll_application/mainscreens/portfolio_screen/portfolio_result.dart';
import 'package:ipoll_application/services/global_methods.dart';
import 'package:ipoll_application/widgets/timer.dart';

class PortfolioWidget extends StatelessWidget {
  const PortfolioWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLive = false;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      child: GestureDetector(
        onTap: () {
          isLive
              ? null
              : GlobalMethods.navigateTo(
                  ctx: context, routeName: PortfolioResult.routeName);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.red[50],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(
                      'Who is the best Indian Cricketer?',
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
                    text: const TextSpan(
                      text: 'Investment:     ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 56, 56, 56),
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: 'Rs 100',
                          style: TextStyle(
                            color: Color.fromARGB(255, 56, 56, 56),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      text: 'Returns:     ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 56, 56, 56),
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: 'Rs 100',
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
