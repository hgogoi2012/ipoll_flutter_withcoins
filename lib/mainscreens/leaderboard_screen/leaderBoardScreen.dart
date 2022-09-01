import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ipoll_application/mainscreens/leaderboard_screen/alltimelead.dart';
import 'package:ipoll_application/mainscreens/leaderboard_screen/perweek.dart';
import 'package:ipoll_application/mainscreens/portfolio_screen/close_events.dart';
import 'package:ipoll_application/mainscreens/portfolio_screen/live_events.dart';
import 'package:ipoll_application/widgets/background_container.dart';
import 'package:provider/provider.dart';

import '../../providers/ranking_provider.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ranksProvider = Provider.of<RanksProvider>(context, listen: false);
    ranksProvider.fetchAllTimeRanks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leader Board'),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _controller,
          indicatorPadding: const EdgeInsets.all(10),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          tabs: <Widget>[
            const Tab(
              text: "All-Time",
            ),
            const Tab(
              text: 'Last 7 Days',
            ),
          ],
        ),
      ),
      body: BackgroundContainer(
          child: TabBarView(
        controller: _controller,
        children: <Widget>[
          const AllTimeLead(),
          const PerWeekLead(),
        ],
      )),
    );
  }
}
