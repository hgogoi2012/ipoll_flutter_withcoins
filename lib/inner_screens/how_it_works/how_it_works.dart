import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ipoll_application/inner_screens/widget/backarrow_nav.dart';

class HowitWorksScreen extends StatelessWidget {
  const HowitWorksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        leading: const BackArrowNav(),
        title: const Text(
          'How it Works',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            paraWidget(
              'iPoll enables you to express your opinion, take stands, showcase support to your favourites by participating in polls designed around everyday happenings, and thereby earn rewards.',
            ),
            paraWidget(
                'Everyday a number of poll gets published. You need to participate in these polls before the deadline. Each poll has a different deadline starting from 1 hour upto 24 hours, some may be valid for a  longer duration also (say, 1 week)'),
            paraWidget(
                'This has no dependence with the real events consequence on which the polls are made , hence it is not prediction, gambling or  betting. This is  voting, just like in an election.'),
            paraWidget(
              'Our aim is to facilitate netizens to practise a habit of critical thinking while consuming anything in the internet. ',
            ),
            paraWidget(
              'Once the poll gets over, the results are out.',
            ),
            paraWidget(
              'The reward system:',
            ),
            inTextWidget('- On login you get 100 coins in your wallet.'),
            inTextWidget(
                '- To participate in each poll there is a voting fee of   1,2, 5 or 10 coins. '),
            inTextWidget(
                '- If your choosen option gets X% of votes (say, 53%), you get 53 coins'),
            inTextWidget(
                '- If your choosen option is the one preferred by majority, then you also gets 2Y coins (Y is the number of coins you voted with)'),
            inTextWidget('- For every referal, you earn 5 coins.'),
            inTextWidget('- Bonus coins are rewarded on reaching milestones '),
            paraWidget(
              'Every sunday evening, a leaderboard gets published, for participating in polls from previous Sunday to Saturday. The top 10 opinion leaders earn rewards.',
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget paraWidget(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: GoogleFonts.roboto(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget inTextWidget(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 15,
      ),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 16,
        ),
      ),
    );
  }
}
