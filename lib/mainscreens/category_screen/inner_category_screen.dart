import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipoll_application/inner_screens/widget/backarrow_nav.dart';

import 'package:ipoll_application/providers/question_provider.dart';
import 'package:ipoll_application/widgets/emptywidget.dart';
import 'package:provider/provider.dart';

import '../../btm_bar.dart';
import '../../models/question_model.dart';
import '../feedscreens/feed_widget.dart';
import 'category_arg.dart';

class InnerCategoryScreen extends StatelessWidget {
  const InnerCategoryScreen({Key? key}) : super(key: key);

  static const routeName = '/InnerCategoryScreen';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CategoryArguments;
    final ThemeData theme = Theme.of(context);

    final questionsProviders = Provider.of<QuestionProvider>(context);
    List<QuestionModel> allQuestions =
        questionsProviders.findByCategory(args.categoryname);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            // elevation: 0,
            backgroundColor: const Color.fromRGBO(230, 239, 250, 1),
            expandedHeight: 200,
            leading: const BackArrowNav(),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                args.categoryname.toString(),
                style: GoogleFonts.roboto(
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              background: CachedNetworkImage(
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageUrl: args.coverImage,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    ColoredBox(color: theme.primaryColor),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                allQuestions.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Icon(
                            Icons.feed,
                            color: theme.primaryColor,
                            size: 79,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'No Polls Available for this Category',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Please Check Back Again Later',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                            ),
                          )
                        ],
                      )
                    : DynamicHeightGridView(
                        itemCount: allQuestions.length,
                        crossAxisCount: 1,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        builder: (context, index) {
                          return ChangeNotifierProvider.value(
                            value: allQuestions[index],
                            child: const FeedWidget(),
                          );
                        }),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => BottomBarScreen(
                                  selectedIndex: 0,
                                )),
                        (Route<dynamic> route) => false);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 33,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 160,
                    child: Text(
                      'View all Polls',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildCategory(BuildContext context) {
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    final questionsProviders = Provider.of<QuestionProvider>(context);
    List<QuestionModel> allQuestions =
        questionsProviders.findByCategory(catName);
    return SliverToBoxAdapter(
      child: allQuestions.isEmpty
          ? const EmptyWidget(
              icon: Icons.hourglass_empty,
              title: 'No Polls yet',
              subtitle: 'Please check back again',
            )
          : DynamicHeightGridView(
              itemCount: allQuestions.length,
              crossAxisCount: 1,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              builder: (context, index) {
                return ChangeNotifierProvider.value(
                  value: allQuestions[index],
                  child: const FeedWidget(),
                );
              }),
    );
  }
}
