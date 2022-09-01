import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipoll_application/btm_bar.dart';
import 'package:ipoll_application/inner_screens/wallet/wallet_screen.dart';
import 'package:ipoll_application/mainscreens/feedscreens/bottomscreenarg.dart';
import 'package:provider/provider.dart';

import 'package:ipoll_application/const/snackbar.dart';

import '../../providers/user_provider.dart';
import '../widget/backarrow_nav.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({Key? key, this.selectedOption = ''}) : super(key: key);
  static const routeName = '/AddMoneyScreen';
  final String selectedOption;
  

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> addMoney(String requestamount, BuildContext context) async {
    final isValid = _formKey.currentState!.validate();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final args =
        ModalRoute.of(context)!.settings.arguments as BottomScreenArguments;

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      userProvider
          .updateWallet(
              amount: int.parse(_amountController.text), context: context)
          .then((value) {
        setState(() {
          isLoading = false;
          if (args.fromBottom) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => BottomBarScreen(selectedIndex: 0),
                ),
                (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
              WalletScreen.routeName,
              (Route<dynamic> route) => false,
            );
          }
        });
        ShowSnackBar.snackbar(content: 'Recharge Successful', context: context);
      });
    }
  }

  final TextEditingController _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userProviders = Provider.of<UserProvider>(context, listen: false);
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
          'Recharge Wallet',
          style: TextStyle(color: theme.focusColor),
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
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 25,
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
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      ),
                    ]),
                child: Column(
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
                          return Column(
                            children: [
                              amount < 10
                                  ? const Text('Low Balance',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ))
                                  : const Text('Available Balance',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      )),
                              const SizedBox(
                                height: 5,
                              ),
                              Text('₹ ${amount.toString()}',
                                  style: TextStyle(
                                    color:
                                        amount < 10 ? Colors.red : Colors.green,
                                    fontSize: 44,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      future: balance,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Topup Wallet',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an amount';
                          }
                          if (int.parse(value.toString()) < 5) {
                            return 'Minimum Recharge amount is Rs 5';
                          }

                          return null;
                        },
                        maxLines: 1,
                        maxLength: 4,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                        cursorColor: const Color.fromARGB(255, 63, 88, 177),
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
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: theme.primaryColor,
                            width: 2,
                          )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Recommended',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _amountController.text = 100.toString();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              textStyle: const TextStyle(),
                              elevation: 0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Color.fromARGB(255, 63, 88, 177),
                              )),
                          child: const Text(
                            '₹ 100',
                            style: TextStyle(
                              color: Color.fromARGB(255, 63, 88, 177),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _amountController.text = 200.toString();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              textStyle: const TextStyle(),
                              elevation: 0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Color.fromARGB(255, 63, 88, 177),
                              )),
                          child: const Text(
                            '₹ 200',
                            style: TextStyle(
                              color: Color.fromARGB(255, 63, 88, 177),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _amountController.text = 500.toString();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              textStyle: const TextStyle(),
                              elevation: 0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Color.fromARGB(255, 63, 88, 177),
                              )),
                          child: const Text(
                            '₹ 500',
                            style: TextStyle(
                              color: Color.fromARGB(255, 63, 88, 177),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMoney(
                          _amountController.text,
                          context,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 15,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 63, 88, 177),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: isLoading
                            ? const SpinKitCircle(
                                color: Colors.white,
                                size: 25,
                              )
                            : const Text(
                                'PROCEED TO TOPUP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
