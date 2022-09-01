import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ipoll_application/inner_screens/notification_screen/notification_chip.dart';
import 'package:ipoll_application/models/notification_model.dart';
import 'package:ipoll_application/no_internet.dart';
import 'package:ipoll_application/services/no_internet.dart';
import 'package:ipoll_application/widgets/emptywidget.dart';
import 'package:provider/provider.dart';

import '../../providers/notification_provider.dart';
import '../../widgets/background_container.dart';
import '../../widgets/empty_screen_fetch.dart';
import '../widget/backarrow_nav.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static const routeName = '/NotificationScreen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<List<NotificationModel>> fetchAllNotifications() async {
    final notificationProviders =
        Provider.of<NotificationProvider>(context, listen: false);
    await notificationProviders.fetchNotifications();

    return notificationProviders.getallNotifications;
  }

  @override
  Widget build(BuildContext context) {
    bool _showDialog = false;
    bool _isempty = true;

    return Scaffold(
      appBar: AppBar(
        leading: const BackArrowNav(),
        backgroundColor: const Color.fromRGBO(63, 88, 177, 1),
        title: const Text(
          'Notification',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Consumer<InternetService>(builder: (context, model, child) {
        return model.internetTracker
            ? FutureBuilder(
                future: fetchAllNotifications(),
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
                  final allnotifications =
                      snapshot.data as List<NotificationModel>;
                  bool isEmpty = allnotifications.isNotEmpty ? false : true;
                  return isEmpty
                      ? const Center(
                          child: EmptyWidget(
                            title: 'No Notifications yet',
                            subtitle:
                                'Tap on the below button,explore the events and start trading',
                            icon: Ionicons.notifications,
                          ),
                        )
                      : BackgroundContainer(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Flexible(
                                child: ListView.builder(
                                    itemCount: allnotifications.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return ChangeNotifierProvider.value(
                                        value: allnotifications[index],
                                        child: const NotificationChip(),
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
