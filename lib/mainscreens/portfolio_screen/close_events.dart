import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ipoll_application/mainscreens/portfolio_screen/live_events_widget.dart';
import 'package:ipoll_application/widgets/background_container.dart';
import 'package:ipoll_application/widgets/emptywidget.dart';
import 'package:provider/provider.dart';

import '../../models/poll_result_model.dart';
import '../../providers/result_provider.dart';

class CloseEventsScreen extends StatelessWidget {
  const CloseEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final resultProviders = Provider.of<ResultProvider>(context);
    List<PollResultModel> allExpiredPoll = resultProviders.findExpiredPoll;
    bool isEmpty = allExpiredPoll.isNotEmpty ? false : true;
    return isEmpty
        ? const EmptyWidget(
            icon: Ionicons.ios_information_circle_outline,
            title: 'No Closed Trading found',
            subtitle: 'Tap the button below to explore all ongoing polls',
          )
        : BackgroundContainer(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: ListView.builder(
                      itemCount: allExpiredPoll.length,
                      itemBuilder: (BuildContext context, index) {
                        return ChangeNotifierProvider.value(
                          value: allExpiredPoll[index],
                          child: const LivePageWidget(),
                        );
                      }),
                ),
              ],
            ),
          );
  }
}
