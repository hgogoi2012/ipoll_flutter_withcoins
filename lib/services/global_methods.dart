import 'package:flutter/material.dart';
import 'package:ipoll_application/const/snackbar.dart';


class GlobalMethods {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static checkLength({required name}) {
    int len = 0;
    if (name != null) {
      len = name!.length;
    } else {
      len = 0;
    }
  }

  // static void checkLatestVersion(BuildContext context) async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();

  //   String version = packageInfo.version;

  //   final databaseReference = FirebaseDatabase.instance.ref();

  //   databaseReference
  //       .child("version")
  //       .child("LatestRealase")
  //       .once()
  //       .then((data) {
  //     Version versionNumberFromDatabase =
  //         Version.parse(data.snapshot.value.toString());
  //     if (versionNumberFromDatabase > Version.parse(version)) {
  //       errorDialog(
  //           subtitle:
  //               'Please visit www.ipollz.com and download the latest version',
  //           context: context);
  //     } else {
  //       print("The app doesn't to be need updated ");
  //     }
  //   });
  // }

  static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            title: Row(children: const [
              SizedBox(
                width: 8,
              ),
              Flexible(child: Text('New Version of iPOLL is available')),
            ]),
            content: Flexible(
              child: Text(
                subtitle,
              ),
            ),
          );
        });
  }

  static Future<void> infoDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            content: Text(
              subtitle,
            ),
          );
        });
  }
}
