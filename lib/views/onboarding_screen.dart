import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../colors.dart';
import 'home_screen.dart';

class OnBoardingScreenOne extends StatefulWidget {
  const OnBoardingScreenOne({super.key});

  @override
  State<OnBoardingScreenOne> createState() => _OnBoardingScreenOneState();
}

class _OnBoardingScreenOneState extends State<OnBoardingScreenOne> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _buildImage(String assetName,
      [double width = 600, double height = 600]) {
    return Image.asset(
      'assets/images/$assetName',
      width: width,
      height: height,
    );
  }

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.white,
          allowImplicitScrolling: true,
          autoScrollDuration: 3000,
          infiniteAutoScroll: true,
          pages: [
            PageViewModel(
              image: _buildImage("onboard_screen_one.png"),
              titleWidget: Text(
                "Track your garbage truck",
                style: GoogleFonts.roboto(
                    color: primary.shade600,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              bodyWidget: Text(
                "Know where the garbage truck is and\n don't miss to dump your trash",
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color(0xff696969),
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            PageViewModel(
              image: _buildImage("onboard_screen_two.png"),
              titleWidget: Text(
                "Click and Upload",
                style: GoogleFonts.roboto(
                    color: primary.shade600,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              bodyWidget: Text(
                "Click and upload anytime, anywhere and your complaint will be fixed",
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color(0xff696969),
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            PageViewModel(
              image: _buildImage("onboard_screen_three.png"),
              titleWidget: Text(
                "3R's for life",
                style: GoogleFonts.roboto(
                    color: primary.shade600,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              bodyWidget: Text(
                "Segregate your waste and learn",
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: const Color(0xff696969),
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          curve: Curves.fastLinearToSlowEaseIn,
          back: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          skip: const Text('Skip',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
          next: const Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
          done: Text('Done',
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black)),
          onDone: () => _onIntroEnd(context),
          onSkip: () => _onIntroEnd(context),
          showBackButton: true,
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            color: Color(0xFFBDBDBD),
            activeSize: Size(16.0, 16.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        )),
      ),
    );
  }
}
