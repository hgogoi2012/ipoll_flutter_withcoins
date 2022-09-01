import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class WalletListWidget extends StatelessWidget {
  const WalletListWidget({
    Key? key,
    required this.title,
    required this.icon,
    this.isverify = false,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final bool isverify;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 7,
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(
                  11,
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(230, 239, 250, 1),
                ),
                child: Icon(icon),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              isverify
                  ? const Icon(
                      Icons.info_rounded,
                      color: Colors.deepOrangeAccent,
                      size: 16,
                    )
                  : const SizedBox()
            ],
          ),
          const Icon(
            IconlyLight.arrow_right_2,
            color: Colors.grey,
          )
        ]));
  }
}
