import 'package:flutter/material.dart';

import 'package:ipoll_application/inner_screens/view_all_transcations/trasncation_chip.dart';
import 'package:ipoll_application/inner_screens/widget/backarrow_nav.dart';
import 'package:ipoll_application/widgets/emptywidget.dart';
import 'package:provider/provider.dart';

import '../../models/trasncation_model.dart';
import '../../no_internet.dart';
import '../../providers/transaction_provider.dart';
import '../../services/no_internet.dart';
import '../../widgets/background_container.dart';
import '../../widgets/empty_screen_fetch.dart';

class ViewAllTranscations extends StatefulWidget {
  const ViewAllTranscations({Key? key}) : super(key: key);

  @override
  State<ViewAllTranscations> createState() => _ViewAllTranscationsState();
}

class _ViewAllTranscationsState extends State<ViewAllTranscations> {
  Future<List<TransactionModel>> fetchAllTransactions() async {
    final transactionProviders =
        Provider.of<TranscationProvider>(context, listen: false);
    await transactionProviders.fetchTranscations();

    return transactionProviders.getallTransactions;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const BackArrowNav(),
        backgroundColor: theme.primaryColor,
        title: Text(
          'Transactions',
          style: TextStyle(color: theme.focusColor),
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
                  final alltranscations =
                      snapshot.data as List<TransactionModel>;
                  bool isEmpty = alltranscations.isNotEmpty ? false : true;
                  return isEmpty
                      ? const Center(
                          child: EmptyWidget(
                          icon: Icons.money,
                          title: 'No Transcations found',
                          subtitle:
                              'Tap the button below to explore all events',
                        ))
                      : BackgroundContainer(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Flexible(
                                child: ListView.builder(
                                    itemCount: alltranscations.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return ChangeNotifierProvider.value(
                                        value: alltranscations[index],
                                        child: const TransactionChip(),
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
