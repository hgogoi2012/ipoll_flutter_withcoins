import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ipoll_application/mainscreens/portfolio_screen/close_events.dart';
import 'package:ipoll_application/mainscreens/portfolio_screen/live_events.dart';
import 'package:ipoll_application/no_internet.dart';
import 'package:ipoll_application/services/no_internet.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({
    Key? key,
    this.navigateToClose = false,
  }) : super(key: key);
  static const routeName = '/PortfolioScreen';
  final bool navigateToClose;

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
    if (widget.navigateToClose) {
      _controller.animateTo(1);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetService>(builder: (context, model, child) {
      return model.internetTracker
          ? DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color.fromRGBO(63, 88, 177, 1),
                  elevation: 0,
                  centerTitle: true,
                  title: const Text(
                    'Your Portfolio',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  bottom: TabBar(
                    controller: _controller,
                    indicatorPadding: const EdgeInsets.all(10),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    tabs: <Widget>[
                      const Tab(
                        text: "Live Events",
                      ),
                      const Tab(
                        text: 'Closed',
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    const LiveEventsScreen(),
                    const CloseEventsScreen()
                  ],
                ),
              ),
            )
          : const NoInternetPage();
    });
  }
}
