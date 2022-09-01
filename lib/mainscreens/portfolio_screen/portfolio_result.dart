import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipoll_application/inner_screens/widget/backarrow_nav.dart';
import 'package:ipoll_application/mainscreens/portfolio_screen/result_row.dart';
import 'package:ipoll_application/mainscreens/portfolio_screen/runningtimer.dart';
import 'package:ipoll_application/widgets/empty_screen_fetch.dart';
import 'package:ipoll_application/widgets/timer.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../../providers/result_provider.dart';

class PortfolioResult extends StatefulWidget {
  const PortfolioResult({Key? key}) : super(key: key);
  static const routeName = '/PortflioResult';

  @override
  State<PortfolioResult> createState() => _PortfolioResultState();
}

class _PortfolioResultState extends State<PortfolioResult>
    with TickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 3);

    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionId = ModalRoute.of(context)!.settings.arguments as String;
    final resultProviders = Provider.of<ResultProvider>(context);
    final findsinglepoll = resultProviders.findPollById(questionId);
    final ThemeData theme = Theme.of(context);
    final DateTime getDateTime = DateTime.parse(findsinglepoll.time);
    int abc = getDateTime.millisecondsSinceEpoch;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: Text(
            'Poll Portfolio',
            style: TextStyle(color: theme.focusColor),
          ),
          leading: const BackArrowNav(),
          elevation: 0,
        ),
        body: FutureBuilder(
          future: resultProviders.generateChartDatas(questionId: questionId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                final dataMap = snapshot.data as Map<String, double>;

                return ColoredBox(
                  color: const Color.fromRGBO(230, 239, 250, 1),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                            color: theme.focusColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 206, 206, 206)
                                    .withOpacity(0.5),
                                spreadRadius: 1, //spread radius
                                blurRadius: 5, // blur radius
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ]),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                  imageUrl: findsinglepoll.image,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const SpinKitFoldingCube(
                                        color: Colors.black,
                                      )),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Flexible(
                              child: Text(
                                findsinglepoll.question,
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  height: 1,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: theme.focusColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 206, 206, 206)
                                  .withOpacity(0.5),
                              spreadRadius: 1, //spread radius
                              blurRadius: 5, // blur radius
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            findsinglepoll.isLive
                                ? const SizedBox()
                                : PieChart(
                                    dataMap: dataMap,
                                    chartType: ChartType.disc,
                                    chartRadius:
                                        MediaQuery.of(context).size.width / 2.2,
                                    baseChartColor:
                                        Colors.grey[50]!.withOpacity(0.15),
                                    legendOptions: const LegendOptions(
                                      legendPosition: LegendPosition.left,
                                      legendShape: BoxShape.rectangle,
                                    ),
                                    chartValuesOptions:
                                        const ChartValuesOptions(
                                      showChartValuesInPercentage: true,
                                    ),
                                  ),
                            findsinglepoll.isLive
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0,
                                      vertical: 25,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Your Choice',
                                              style: GoogleFonts.lato(
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              constraints: const BoxConstraints(
                                                minWidth: 60,
                                              ),
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 9,
                                                horizontal: 7,
                                              ),
                                              decoration: BoxDecoration(
                                                color: theme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                findsinglepoll.selectedOption,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Majority Choice',
                                              style: GoogleFonts.lato(
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              constraints: const BoxConstraints(
                                                minWidth: 60,
                                              ),
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 9,
                                                horizontal: 7,
                                              ),
                                              decoration: BoxDecoration(
                                                color: theme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                findsinglepoll.majority!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                            findsinglepoll.isLive
                                ? ResultRowWidget(
                                    title: 'Your Choice :',
                                    data: findsinglepoll.selectedOption,
                                  )
                                : const SizedBox(),
                            ResultRowWidget(
                              title: 'Your Investment :',
                              data: '${findsinglepoll.selectedAmount} coins',
                              isWon: true,
                            ),
                            findsinglepoll.isLive
                                ? const SizedBox()
                                : ResultRowWidget(
                                    title: 'You Won :',
                                    data:
                                        '${findsinglepoll.winningAmount} coins',
                                  ),
                            findsinglepoll.isLive
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 9.0,
                                      horizontal: 18,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Time Remaining:',
                                          style: GoogleFonts.lato(
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Flexible(
                                          child: RunningTimerWidget(
                                            remainingtime: abc,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }

            // Displaying LoadingSpinner to indicate waiting state
            return const EmptyFetchScreen();
          },
        ));
  }
}
