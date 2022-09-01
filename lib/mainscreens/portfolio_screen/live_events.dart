import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ipoll_application/mainscreens/portfolio_screen/live_events_widget.dart';
import 'package:ipoll_application/widgets/background_container.dart';
import 'package:ipoll_application/widgets/empty_screen_fetch.dart';
import 'package:provider/provider.dart';

import '../../models/poll_result_model.dart';
import '../../providers/result_provider.dart';
import '../../widgets/emptywidget.dart';

class LiveEventsScreen extends StatefulWidget {
  const LiveEventsScreen({Key? key}) : super(key: key);

  @override
  State<LiveEventsScreen> createState() => _LiveEventsScreenState();
}

class _LiveEventsScreenState extends State<LiveEventsScreen> {
  Future<List> fetchLivePolls() async {
    final resultProviders = Provider.of<ResultProvider>(context, listen: false);
    await resultProviders.fetchAllPolls();
    final List<PollResultModel> allLivePoll = resultProviders.findLivePoll;
    return allLivePoll;
  }

  @override
  void initState() {
    // fetchLivePolls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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

        final allLivePoll = snapshot.data as List<PollResultModel>;
        bool isEmpty = allLivePoll.isNotEmpty ? false : true;

        return isEmpty
            ? const EmptyWidget(
                icon: Ionicons.ios_information_circle_outline,
                title: 'No Live Trading found',
                subtitle: 'Tap the button below to explore all ongoing polls',
              )
            : BackgroundContainer(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: RefreshIndicator(
                        child: ListView.builder(
                            itemCount: allLivePoll.length,
                            itemBuilder: (BuildContext context, index) {
                              return ChangeNotifierProvider.value(
                                value: allLivePoll[index],
                                child: const LivePageWidget(),
                              );
                            }),
                        onRefresh: () {
                          return Future.delayed(const Duration(seconds: 1), () {
                            fetchLivePolls();

                            setState(() {});
                          });
                        },
                      ),
                    )
                  ],
                ),
              );
      },
      future: fetchLivePolls(),
    );
  }
}
