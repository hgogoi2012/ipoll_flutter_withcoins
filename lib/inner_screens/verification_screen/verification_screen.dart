import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../const/firebase_instance.dart';
import '../widget/backarrow_nav.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _name = TextEditingController();

  final TextEditingController _panController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isVerified = false;

  @override
  void dispose() {
    _name.dispose();
    _panController.dispose();

    super.dispose();
  }

  Future<void> verifyDetails() async {
    final isValid = _formKey.currentState!.validate();
    String uid = authInstance.currentUser!.uid;

    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        isLoading = true;
      });

      await http.post(
        Uri.parse(
            'https://asia-south1-ipoll-da231.cloudfunctions.net/ipoll/verification'),
        body: {
          'name': _name.text,
          'pan': _panController.text,
          'userId': uid,
        },
      ).then((value) {
        setState(() {
          isLoading = false;
        });
        // Navigator.push(
        //   context,
        //   PageTransition(
        //       type: PageTransitionType.fade, child: const SuccessScreen()),
        // );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        leading: const BackArrowNav(),
        elevation: 0,
        title: Text(
          'Verification',
          style: GoogleFonts.lato(
            color: theme.focusColor,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(230, 239, 250, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      _name.text = value.toUpperCase();
                      _name.selection = TextSelection.fromPosition(
                          TextPosition(offset: _name.text.length));
                    },
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name can\'t be empty';
                      }
                      return null;
                    },
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  TextFormField(
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                    controller: _panController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Pan number can\'t be empty';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _panController.text = value.toUpperCase();
                      _panController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _panController.text.length));
                    },
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Pan Number',
                      labelStyle: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                verifyDetails();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: !isLoading
                    ? Text(
                        'Verify',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : SpinKitCircle(
                        size: 20,
                        color: Colors.white,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
