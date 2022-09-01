import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  int progress = 0;

  // ReceivePort _receivePort = ReceivePort();

  // static downloadingCallback(id, status, progress) {
  //   ///Looking up for a send port
  //   SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

  //   ///ssending the data
  //   sendPort?.send([id, status, progress]);
  // }

  // Future<void> startDownload() async {
  //   final status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     final externalDir = await getExternalStorageDirectory();
  //     print(externalDir);



  //     print(taskId);
  //     if (progress == 100) {
  //       await Future.delayed(Duration(seconds: 3));

  //     }
  //   } else {
  //     print('perm rejected');
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () {
            // startDownload();
          },
          child: Text('Download')),
    );
  }
}
