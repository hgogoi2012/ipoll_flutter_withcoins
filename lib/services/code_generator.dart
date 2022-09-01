import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../const/firebase_instance.dart';

class DynamicLinkService {
  static Random random = Random();

  DynamicLinkService._();
  static DynamicLinkService? _instance;

  static DynamicLinkService? get instance {
    _instance ??= DynamicLinkService._();
    return _instance;
  }

  final _dynamicLink = FirebaseDynamicLinks.instance;

  static Future<Map<String, String>> createReferLink() async {
    final User? user = authInstance.currentUser;
    final uid = user!.uid.toString().substring(3, 6);
    var id = random.nextInt(92) + 544;
    final getRefer = '$uid${id.toString().substring(0, 2)}';

    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://topoll.page.link',
      link: Uri.parse('https://topoll.page.link/refer?code=$getRefer'),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.ipoll',
        minimumVersion: 1,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'REFER A FRIEND & EARN',
        description: 'Install the app and getp 30 coins upon install',
        imageUrl: Uri.parse(
            'https://moru.com.np/wp-content/uploads/2021/03/Blog_refer-Earn.jpg'),
      ),
    );

    final dynamicLink = FirebaseDynamicLinks.instance;

    final shortLink = await dynamicLink.buildShortLink(
      dynamicLinkParameters,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );

    return {
      "url": shortLink.shortUrl.toString(),
      "refercode": getRefer,
    };
  }

  // String _generateCode() {
  //   final User? user = authInstance.currentUser;
  //   final uid = user!.uid.toString().substring(3, 8).toUpperCase();
  //   var id = random.nextInt(92143543) + 09451234356;
  //   return '$id${id.toString().substring(0, 4)}';
  // }

  Future<void> handleDynamicLinks() async {
    //Get initial dynamic link if app is started using the link

    final data = await _dynamicLink.getInitialLink();
    if (data != null) {
      _handleDeepLink(data);
    }

    //handle foreground
    _dynamicLink.onLink.listen((event) {
      _handleDeepLink(event);
    }).onError((v) {
      print('couldnt fetch');
    });
  }

  static Future<String> checkCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('code');

    String? action = prefs.getString('code');

    action ??= "nocode";

    return action;
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;

    bool isRefer = deepLink.pathSegments.contains('refer');

    if (isRefer) {
      var code = deepLink.queryParameters['code'];
      if (code != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('code');

        await prefs.setString('code', code);
      }
    }
  }
}
