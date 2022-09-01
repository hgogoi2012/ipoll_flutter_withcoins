import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

import '../../models/trasncation_model.dart';
import '../../models/withdrawl_model.dart';

class WithdrawlChip extends StatelessWidget {
  const WithdrawlChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final withdrawlModel = Provider.of<WithdrawlModel>(context);
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ).copyWith(
          bottom: 17,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ).copyWith(bottom: 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 206, 206, 206).withOpacity(0.5),
                spreadRadius: 3, //spread radius
                blurRadius: 5, // blur radius
                offset: const Offset(0, 0), // changes position of shadow
                //first paramerter of offset is left-right
                //second parameter is top to down
              ),
            ]),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(
                    5,
                  ),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black87,
                  ),
                  child: const Icon(
                    Icons.money_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(
                  width: 17,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rs ${withdrawlModel.amount.toString()}',
                          style: GoogleFonts.lato(
                            fontSize: 20,
                          )),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        withdrawlModel.isProcessed ? 'Processed' : 'Processing',
                        style: TextStyle(
                          color: withdrawlModel.isProcessed
                              ? Colors.green
                              : Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Reference Id : ${withdrawlModel.withdrawlid}',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
