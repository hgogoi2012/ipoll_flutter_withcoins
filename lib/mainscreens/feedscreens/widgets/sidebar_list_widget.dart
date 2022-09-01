import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class SidebarListWidget extends StatelessWidget {
  const SidebarListWidget(
      {Key? key, required this.title, required this.icon, this.isInfo = false})
      : super(key: key);

  final String title;
  final IconData icon;
  final bool isInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: ColoredBox(
        color: isInfo ? Colors.white30 : Colors.white,
        child: ListTile(
          leading: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(
              11,
            ),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(230, 239, 250, 1),
            ),
            child: Icon(
              icon,
              color: Colors.black87,
              size: 17,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          trailing: isInfo
              ? const SizedBox()
              : const Icon(
                  IconlyLight.arrow_right_2,
                  color: Colors.black,
                  size: 16,
                ),
        ),
      ),
    );
  }
}
