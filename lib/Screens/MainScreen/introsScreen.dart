import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Screens/MainScreen/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';




class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/Icons/appIcon.png',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      autoScrollDuration: 3000,
      infiniteAutoScroll: true,
      // globalHeader: Align(
      //   alignment: Alignment.topRight,
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 16, right: 16),
      //       child: _buildImage('assets/Icons/appIcon.png', 100),
      //     ),
      //   ),
      // ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Let\'s go right away!',
            style: TextStyle(fontSize: 16.0,fontFamily: ConstFont.popinsMedium),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          titleWidget: Text("Locate the Destination",
            style: TextStyle(fontSize: 26.0,fontWeight: FontWeight.w600,fontFamily: ConstFont.popinsMedium),
            textAlign: TextAlign.center,

          ),
          bodyWidget: Text("Your destination is your fingertips. Open app & enter where you want to go",
            style: TextStyle(fontSize: 16.0,fontFamily: ConstFont.popinsRegular),
            textAlign: TextAlign.center,
          ),
          image: _buildImage('assets/Images/rangeRover.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Text("Select Your Choice",
            style: TextStyle(fontSize: 26.0,fontWeight: FontWeight.w600,fontFamily: ConstFont.popinsMedium),
            textAlign: TextAlign.center,

          ),
          bodyWidget: Text("Get quick access to frequent cars and save them as a favorites",
            style: TextStyle(fontSize: 16.0,fontFamily: ConstFont.popinsRegular),
            textAlign: TextAlign.center,
          ),
          image: _buildImage('assets/Images/bmw.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Text("Get Your Car",
            style: TextStyle(fontSize: 26.0,fontWeight: FontWeight.w600,fontFamily: ConstFont.popinsMedium),
            textAlign: TextAlign.center,

          ),
          bodyWidget: Text("Fastest way to book car without the hassie of waiting & hanging for price",
            style: TextStyle(fontSize: 16.0,fontFamily: ConstFont.popinsRegular),
            textAlign: TextAlign.center,
          ),
          image: _buildImage('assets/Images/audi.png'),
          decoration: pageDecoration,
        ),

      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
