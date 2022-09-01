import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipoll_application/mainscreens/leaderboard_screen/leadeboard_chip.dart';
import 'package:ipoll_application/models/ranking_model.dart';
import 'package:provider/provider.dart';

import '../../providers/ranking_provider.dart';
import '../../widgets/empty_screen_fetch.dart';
import '../../widgets/emptywidget.dart';

class PerWeekLead extends StatefulWidget {
  const PerWeekLead({Key? key}) : super(key: key);

  @override
  State<PerWeekLead> createState() => _PerWeekLeadState();
}

class _PerWeekLeadState extends State<PerWeekLead> {
  bool isEmpty = false;
  late Timestamp getTime;

  Future<List> fetchAllTimeRank() async {
    final rankProviders = Provider.of<RanksProvider>(context, listen: false);
    await rankProviders.fetchWeeklyRanks();
    final List<RankingModel> allTimeRanks = rankProviders.getweeklyRank;
    getTime = rankProviders.time;

    return allTimeRanks;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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

        final allTimeRanks = snapshot.data as List<RankingModel>;
        bool isEmpty = allTimeRanks.isNotEmpty ? false : true;

        return isEmpty
            ? const EmptyWidget(
                icon: Ionicons.ios_information_circle_outline,
                title: 'No Leaderboard',
                subtitle: 'Leaderboard not available yet',
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Last Updated  ${GetTimeAgo.parse(getTime.toDate())}',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'RANK',
                        style: GoogleFonts.roboto(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'POINTS',
                        style: GoogleFonts.roboto(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Text(
                        'PLAYER',
                        style: GoogleFonts.roboto(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: ListView.builder(
                        itemCount: allTimeRanks.length,
                        itemBuilder: (BuildContext context, index) {
                          return ChangeNotifierProvider.value(
                            value: allTimeRanks[index],
                            child: const LeaderBoardChip(),
                          );
                        }),
                  ),
                ],
              );
      },
      future: fetchAllTimeRank(),
    );
  }
}
