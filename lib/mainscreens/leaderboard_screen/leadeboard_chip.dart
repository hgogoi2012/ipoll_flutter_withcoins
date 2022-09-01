import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ipoll_application/models/ranking_model.dart';
import 'package:provider/provider.dart';

class LeaderBoardChip extends StatelessWidget {
  const LeaderBoardChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rankingModel = Provider.of<RankingModel>(context);
    final ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 7,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: rankingModel.isCurrentUser ? theme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 43,
          ),
          Text(
            rankingModel.rank,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: rankingModel.isCurrentUser ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(
            width: rankingModel.isCurrentUser ? 38 : 55,
          ),
          Text(
            rankingModel.points,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: rankingModel.isCurrentUser ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(
            width: rankingModel.points.length == 2 ? 63 : 55,
          ),
          Flexible(
            child: Row(
              children: [
                ClipOval(
                    child: SizedBox.fromSize(
                  size: const Size.fromRadius(15),
                  child: CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: rankingModel.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SpinKitFoldingCube(
                            color: Colors.black,
                            size: 10,
                          )),
                )),
                const SizedBox(
                  width: 9,
                ),
                Expanded(
                  child: Text(
                    rankingModel.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: rankingModel.isCurrentUser
                          ? Colors.white
                          : Colors.black,
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
}
