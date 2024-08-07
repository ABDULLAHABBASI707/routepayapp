import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:routepayapp/ui/home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    final pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: Colors.purple,
          letterSpacing: 2,
        ),
        bodyTextStyle: TextStyle(
          fontSize: 18,
          letterSpacing: 1,
          fontWeight: FontWeight.w900,
        ),
        bodyPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        pageColor: Colors.white,
        imagePadding: EdgeInsets.zero);

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Fare Customization",
          body:
              "Display real-time fare estimates before users confirm their journey.Plan and budget accordingly.",
          image: Image.asset(
            "assets/fare.jpg",
            width: 200,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Adventure Theme",
          body:
              "Embark on your next adventure with RoutePay.Navigate the unknown effortlessly.",
          image: Image.asset(
            "assets/adventure.jpg",
            width: 200,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Comfortable Zone",
          body:
              "Your sustainable travel companion.Welcome to the nocturnal journey",
          image: Image.asset(
            "assets/comfortable_zone.jpg",
            width: 200,
          ),
          decoration: pageDecoration,
          footer: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text(
                'Lets Start',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
      showSkipButton: false,
      showDoneButton: false,
      showBackButton: true,
      back: const Text(
        'Back',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.purple,
          fontSize: 20,
        ),
      ),
      next: const Text(
        'Next',
        style: TextStyle(
            fontWeight: FontWeight.w900, color: Colors.purple, fontSize: 20),
      ),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10),
          activeSize: const Size(20, 10),
          activeColor: Colors.purple,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          )),
    );
  }
}
