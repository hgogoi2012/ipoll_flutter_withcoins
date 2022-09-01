import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipoll_application/inner_screens/request_withdrawl/view_all_withdraw.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../const/firebase_instance.dart';
import '../../providers/user_provider.dart';
import '../../providers/withdrawl_provider.dart';
import '../widget/backarrow_nav.dart';

class RequestWithdrawl extends StatefulWidget {
  const RequestWithdrawl({Key? key}) : super(key: key);
  static const routeName = '/AddMoneyScreen';

  @override
  State<RequestWithdrawl> createState() => _RequestWithdrawlState();
}

class _RequestWithdrawlState extends State<RequestWithdrawl> {
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> requestWithdrawl(String requestamount) async {
    final isValid = _formKey.currentState!.validate();
    final withdrawlProvider =
        Provider.of<WithdrawlProvider>(context, listen: false);

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      withdrawlProvider
          .requestwithdrawl(
        amount: int.parse(requestamount),
        context: context,
      )
          .then((value) {
        setState(() {
          isLoading = false;
          _amountController.text = '';
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Success!'),
                  content: Text(
                    'You will receive your request amount in your account UPI address within next 24 hour',
                    style: GoogleFonts.lato(),
                  ),
                  actions: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'))
                  ],
                );
              });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProviders = Provider.of<UserProvider>(context);
    final ThemeData theme = Theme.of(context);
    Future<int> balance = userProviders.fetchUser().then((value) {
      final userDetails = userProviders.getUser;
      final int amount = userDetails.amount!;
      return amount;
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackArrowNav(),
        title: Text(
          'Request Withdrawl',
          style: GoogleFonts.lato(
            color: theme.focusColor,
          ),
        ),
        elevation: 0,
        backgroundColor: theme.primaryColor,
      ),
      body: ColoredBox(
        color: const Color.fromRGBO(230, 239, 250, 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final amount = snapshot.data as int;
                    return Form(
                      key: _formKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 35,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 206, 206, 206)
                                    .withOpacity(0.5),
                                spreadRadius: 1, //spread radius
                                blurRadius: 5, // blur radius
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            amount < 10
                                ? const Text('Low Balanice',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ))
                                : const Text('Withdrawble Balance',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    )),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '₹ ${amount.toString()}',
                              style: TextStyle(
                                color: amount < 10 ? Colors.red : Colors.green,
                                fontSize: 44,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Note : Promotional amount can\'t be used for withdraw',
                              style: GoogleFonts.lato(
                                color: theme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Enter the amount you want to withdraw',
                              style: GoogleFonts.lato(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _amountController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter an amount';
                                }
                                if (int.parse(value.toString()) > amount) {
                                  return 'Please enter a value less than your available balance';
                                }
                                if (int.parse(value.toString()) < 10) {
                                  return 'Requested Amount should be more than Rs 10';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              maxLength: 4,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                              cursorColor: theme.primaryColor,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: 'Enter amount',
                                counterText: '',
                                hintStyle: GoogleFonts.lato(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                                prefix: const Text(
                                  ' ₹  ',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color.fromARGB(255, 63, 88, 177),
                                  width: 2,
                                )),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                requestWithdrawl(_amountController.text);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 15,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: isLoading
                                    ? const SpinKitCircle(
                                        color: Colors.white,
                                        size: 25,
                                      )
                                    : const Text(
                                        'REQUEST WITHDRAWL',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(PageTransition(
                                      child: const ViewAllWithdrawls(),
                                      type: PageTransitionType.leftToRight,
                                    ));
                                  },
                                  child: Text(
                                    'View all Withdrawls',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                future: balance,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
