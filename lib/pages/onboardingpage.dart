import 'package:flutter/material.dart';
import 'package:blucash_client/pages/login.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:blucash_client/tools/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ON_BOARDING', false);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }

  Widget _buildImage(String assetName, [double width = 150]) {
    return Image.asset('assets/img/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 20.0);

    const pageDecoration = PageDecoration(
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 30.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
// onPressed: () => _onIntroEnd(context),
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "",
          body: "",
          image: Center(
            child: Container(
              width: MediaQuery.of(context).size.width *0.75,
              height: 80,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/img/blucash.png"),
                ),
              ),
            ),
          ),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(1);
            },
            child: const Text(
              "J'ai un compte",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              primary: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 1,
            imageFlex: 1,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.bottomCenter,
          ),
        ),
        PageViewModel(
          title: "",
          body: "Sécurisez vos transactions",
          image: Center(
            child: Image.asset(
              "assets/img/blucash.png",
              width: 150,
            ),
          ),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(2);
            },
            child: const Text(
              "Suivant",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 0.0),
              primary: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "",
          body: "Optimisez votre gestion",
          image: Center(
            child: Image.asset(
              "assets/img/blucash.png",
              width: 150,
            ),
          ),
          footer: ElevatedButton(
            onPressed: () => _onIntroEnd(context),
            child: const Text(
              "Connexion",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 0.0),
              primary: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: false,
      showNextButton: false,
      showDoneButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      curve: Curves.bounceInOut,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
