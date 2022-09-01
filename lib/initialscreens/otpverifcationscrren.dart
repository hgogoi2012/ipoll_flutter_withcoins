import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipoll_application/const/firebase_instance.dart';
import 'package:ipoll_application/fetch_questions.dart';
import 'package:ipoll_application/initialscreens/entermobile_screen.dart';
import 'package:ipoll_application/loading_screen.dart';
import 'package:ipoll_application/services/code_generator.dart';
import 'package:ipoll_application/services/notification_service.dart';
import 'package:ipoll_application/widgets/background_container.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({
    Key? key,
    required this.verificationId,
    required this.resendToken,
    required this.phoneNumber,
  }) : super(key: key);

  final String verificationId;
  final int? resendToken;
  final String phoneNumber;

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  bool _isLoading = false;
  bool _wrongOTP = false;
  void verifyOTP() async {
    setState(() {
      _wrongOTP = false;
      _isLoading = true;
    });
    String otp = _phoneController.text;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authInstance.currentUser;
      final uid = user!.uid;
      final userDocRef =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDocRef.exists) {
      } else {
        final Map<String, String> juiLink =
            await DynamicLinkService.createReferLink();
        final String cmg = await NotificationService.initialize();

        await http.post(
          Uri.parse(
              'https://asia-south1-ipoll-da231.cloudfunctions.net/ipoll/newuser'),
          body: {
            'uid': uid,
            'phoneNumber': user.phoneNumber,
            'referCode': juiLink['refercode'],
            'url': juiLink['url'],
            'cmg': cmg,
          },
        );
        NotificationService.initialize();
      }

      if (userCredential.user != null) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => const FetchQuestions(),
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
      setState(() {
        _isLoading = false;
        _wrongOTP = true;
      });
    }
  }

  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _resendOTP() async {
    setState(() {
      _isLoading = true;
    });
    int? _resendToken;
    FocusScope.of(context).unfocus();

    String phone = widget.phoneNumber;

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          codeSent: (verificationId, resendToken) {
            _resendToken = resendToken;
          },
          verificationCompleted: (credential) {},
          verificationFailed: (ex) {
            print(ex.code.toString());
          },
          forceResendingToken: widget.resendToken,
          codeAutoRetrievalTimeout: (verificationId) {},
          timeout: const Duration(seconds: 30));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: !_isLoading
            ? AppBar(
                elevation: 0,
                backgroundColor: const Color.fromRGBO(230, 239, 250, 1),
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    EnterMobileScreen.routeName,
                    (Route<dynamic> route) => false,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 15,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_sharp,
                      color: Colors.black87,
                      size: 16,
                    ),
                  ),
                ),
              )
            : null,
        body: LoadingManager(
          isLoading: _isLoading,
          child: Center(
            child: BackgroundContainer(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    'assets/images/otp.png',
                    height: 180,
                  ),
                  const Text('Verification Code',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 24)),
                  const SizedBox(
                    height: 15,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Enter the OTP sent to',
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                            text: ' ${widget.phoneNumber}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Pinput(
                      length: 6,
                      pinAnimationType: PinAnimationType.slide,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _phoneController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyDecorationWith(
                        border: Border.all(
                            color: const Color.fromRGBO(114, 178, 238, 1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) => verifyOTP(),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  _wrongOTP
                      ? const Text(
                          'Incorrect OTP',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Didn\'t receive the OTP?',
                          style: TextStyle(color: Colors.black)),
                      const SizedBox(
                        width: 7,
                      ),
                      InkWell(
                        onTap: _resendOTP,
                        child: const Text('Resend OTP',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  // ElevatedButton(
                  //   onPressed: _resendOTP,
                  //   style: ElevatedButton.styleFrom(
                  //       primary: Colors.blueAccent,
                  //       onPrimary: Colors.white,
                  //       shadowColor: Colors.amber),
                  //   child: const Padding(
                  //     padding: EdgeInsets.all(8.0),
                  //     child: Text(
                  //       'VERIFY & PROCEED',
                  //       style: TextStyle(fontSize: 18),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ));
  }
}
