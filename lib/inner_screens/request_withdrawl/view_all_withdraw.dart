import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:ipoll_application/inner_screens/request_withdrawl/withdrawl_chip.dart';

import 'package:ipoll_application/inner_screens/view_all_transcations/trasncation_chip.dart';
import 'package:ipoll_application/inner_screens/widget/backarrow_nav.dart';
import 'package:ipoll_application/widgets/emptywidget.dart';
import 'package:provider/provider.dart';

import '../../models/trasncation_model.dart';
import '../../models/withdrawl_model.dart';
import '../../no_internet.dart';
import '../../providers/withdrawl_provider.dart';
import '../../services/no_internet.dart';
import '../../widgets/background_container.dart';
import '../../widgets/empty_screen_fetch.dart';

class ViewAllWithdrawls extends StatefulWidget {
  const ViewAllWithdrawls({Key? key}) : super(key: key);

  @override
  State<ViewAllWithdrawls> createState() => _ViewAllWithdrawlsState();
}

class _ViewAllWithdrawlsState extends State<ViewAllWithdrawls> {
  Future<List<WithdrawlModel>> fetchAllTransactions() async {
    final withdrawlProviders =
        Provider.of<WithdrawlProvider>(context, listen: false);
    await withdrawlProviders.fetchWithdrawl();

    return withdrawlProviders.getallTransactions;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const BackArrowNav(),
        backgroundColor: theme.primaryColor,
        title: Text(
          'Your Withdrawls',
          style: GoogleFonts.lato(color: theme.focusColor),
        ),
        elevation: 0,
      ),
      body: Consumer<InternetService>(builder: (context, model, child) {
        return model.internetTracker
            ? FutureBuilder(
                future: fetchAllTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const EmptyFetchScreen();
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  }
                  final allwithdrawls = snapshot.data as List<WithdrawlModel>;
                  bool isEmpty = allwithdrawls.isNotEmpty ? false : true;
                  return isEmpty
                      ? const Center(
                          child: EmptyWidget(
                          icon: IconlyLight.document,
                          title: 'No Withdrawls found',
                          subtitle: 'Tap the button below to explore all polls',
                        ))
                      : BackgroundContainer(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Flexible(
                                child: ListView.builder(
                                    itemCount: allwithdrawls.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return ChangeNotifierProvider.value(
                                        value: allwithdrawls[index],
                                        child: const WithdrawlChip(),
                                      );
                                    }),
                              )
                            ],
                          ),
                        );
                })
            : const NoInternetPage();
      }),
    );
  }
}
