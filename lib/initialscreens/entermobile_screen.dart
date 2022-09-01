import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipoll_application/initialscreens/otpverifcationscrren.dart';
import 'package:ipoll_application/loading_screen.dart';

class EnterMobileScreen extends StatefulWidget {
  const EnterMobileScreen({Key? key}) : super(key: key);
  static const routeName = '/EnterMobileScreen';

  @override
  State<EnterMobileScreen> createState() => _EnterMobileScreenState();
}

class _EnterMobileScreenState extends State<EnterMobileScreen> {
  bool _isLoading = false;
  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitMobile() async {
    final isValid = _formKey.currentState!.validate();

    int? resendToken;
    FocusScope.of(context).unfocus();

    String phone = "+91${phoneController.text.trim()}";

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      FocusScope.of(context).unfocus();
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          codeSent: (verificationId, resendToken) {
            resendToken = resendToken;
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => OtpVerifyScreen(
                          verificationId: verificationId,
                          resendToken: resendToken,
                          phoneNumber: phone,
                        )));
          },
          verificationCompleted: (credential) {},
          verificationFailed: (ex) {
            print(ex.code.toString());
          },
          codeAutoRetrievalTimeout: (verificationId) {},
          timeout: const Duration(seconds: 30),
        );
      } on FirebaseAuthException catch (e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          elevation: 0,
          title: RichText(
            text: const TextSpan(
                text: 'i',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'POLL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ))
                ]),
          ),
          centerTitle: true,
        ),
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: LoadingManager(
            isLoading: _isLoading,
            child: Container(
              color: const Color.fromRGBO(230, 239, 250, 1),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    'assets/images/otp.png',
                    height: 180,
                  ),
                  const Text('OTP Verification',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 24)),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'We will send you an',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: ' One Time Password (OTP) ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'on this mobile number.',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Enter Mobile Number',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 36.0),
                              child: TextFormField(
                                controller: phoneController,
                                cursorColor: Colors.black,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(4.0)
                                          .copyWith(top: 15),
                                      child: const Text(
                                        '+91',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 4.0),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 4.0),
                                    )),
                                validator: (value) {
                                  if (value != null && value.length < 10) {
                                    return 'Please enter a valid Phone Number';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: theme.primaryColor,
                        onPrimary: Colors.white,
                        shadowColor: Colors.amber),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: _submitMobile,
                        child: const Text(
                          'VERIFY OTP',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
