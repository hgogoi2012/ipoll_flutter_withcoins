import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  bool isLoading = false;
  // Future<void> checkInternet() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   InternetConnectionChecker().onStatusChange.listen((status) {
  //     final hasInternet = status == InternetConnectionStatus.connected;

  //     setState(() {
  //       if (hasInternet == true) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       } else if (hasInternet == false) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(230, 239, 250, 1),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/nointernet.png'),
          const SizedBox(
            height: 30,
          ),
          Text(
            'No Internet Connection',
            style: GoogleFonts.roboto(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Please check your internet and try again',
            style: GoogleFonts.roboto(
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 35,
          ),
        ],
      ),
    );
  }
}
