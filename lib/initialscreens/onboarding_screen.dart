import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:ipoll_application/initialscreens/entermobile_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      animationDuration: 400,
      curve: Curves.easeIn,
      globalBackgroundColor: const Color.fromARGB(255, 246, 252, 255),
      showDoneButton: true,
      showNextButton: true,
      next: const Text('Next'),
      done: const Text('Done'),
      onDone: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EnterMobileScreen(),
          ),
        );
      },
      pages: [
        PageViewModel(
            title: 'Creating Poll was never so easy',
            body: 'Just 3 clicks and some random text and everything',
            image: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/ipoll-da231.appspot.com/o/onboarding_image_1.png?alt=media&token=8c99500d-559a-460e-b9fa-6a613e726fad',
              ),
            )),
        PageViewModel(
            title: 'Creating Poll was never so easy',
            body: 'Just 3 clicks and some random text and  again random',
            image: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/ipoll-da231.appspot.com/o/onboarding_image_2.png?alt=media&token=f1ddcfc7-0979-4fe3-88f2-cf44ad0e7878',
              ),
            )),
        PageViewModel(
            title: 'Creating Poll was never so easy',
            body: 'Just 3 clicks and some random text and  again random',
            image: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/ipoll-da231.appspot.com/o/onboarding_image_2.png?alt=media&token=f1ddcfc7-0979-4fe3-88f2-cf44ad0e7878',
              ),
            )),
      ],
    );
  }
}
