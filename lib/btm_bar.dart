import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import 'package:ipoll_application/mainscreens/category_screen/category_screen.dart';
import 'package:ipoll_application/mainscreens/portfolio_screen/portfolio_screen.dart';
import 'package:ipoll_application/mainscreens/referral_screen/referral_screen.dart';

import 'mainscreens/feedscreens/feed_screen.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';

  BottomBarScreen({
    Key? key,
    this.selectedIndex = 0,
    this.isClosed = false,
  }) : super(key: key);
  int selectedIndex;

  final bool isClosed;

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  // final List<Map<String, dynamic>> _pages = [
  //   {
  //     'page': const FeedScreen(),
  //     'title': 'Home Screen',
  //   },
  //   {
  //     'page': const CategoryScreen(),
  //     'title': 'Categories Screen',
  //   },
  //   {
  //     'page': PortfolioScreen(
  //       navigateToClose: widget,
  //     ),
  //     'title': 'porrtflio Screen',
  //   },
  //   {
  //     'page': const Text('User'),
  //     'title': 'user Screen',
  //   },
  // ];
  void _selectedPage(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pages = [
      {
        'page': const FeedScreen(),
        'title': 'Home Screen',
      },
      {
        'page': const CategoryScreen(),
        'title': 'Categories Screen',
      },
      {
        'page': PortfolioScreen(
          navigateToClose: widget.isClosed,
        ),
        'title': 'porrtflio Screen',
      },
      {
        'page': const ReferralScreen(),
        'title': 'Reward Screen',
      },
    ];
    return Scaffold(
      body: pages[widget.selectedIndex]['page'],
      bottomNavigationBar: SizedBox(
        height: 56,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: widget.selectedIndex,
          unselectedItemColor:
              const Color.fromRGBO(63, 88, 177, 1).withAlpha(100),
          selectedItemColor: const Color.fromRGBO(63, 88, 177, 1),
          onTap: _selectedPage,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Container(
                child: Icon(
                  widget.selectedIndex == 0
                      ? IconlyBold.home
                      : IconlyLight.home,
                  // size: 14,
                ),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                widget.selectedIndex == 1
                    ? IconlyBold.category
                    : IconlyLight.category,
                // size: 14,
              ),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: Container(
                child: Icon(
                  widget.selectedIndex == 2
                      ? IconlyBold.work
                      : IconlyLight.work,
                  // size: 14
                ),
              ),
              label: "Portfolio",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                widget.selectedIndex == 3
                    ? IconlyBold.activity
                    : IconlyLight.activity,
                // size: 14,
              ),
              label: "Reward",
            ),
          ],
        ),
      ),
    );
  }
}
