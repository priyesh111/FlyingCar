import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/firebase_services/splash_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  SplashServices splashServices = SplashServices();
  bool showNavigationBar = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
    showNavigationBar = true;
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.repeat();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GFAnimation(
                scaleAnimation: animation,
                controller: controller,
                type: GFAnimationType.scaleTransition,
                child: Image.asset("assets/Images/splash.gif")),
          )),
          Text("F L Y I N G    C A R",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  fontFamily: ConstFont.popinsRegular,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
