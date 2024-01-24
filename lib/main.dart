import 'package:car_selling/ConstFile/constColors.dart';
import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/Screens/MainScreen/billScreen.dart';
import 'package:car_selling/Screens/MainScreen/splash.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/MainScreen/feedback.dart';
import 'Screens/MainScreen/introsScreen.dart';
import 'Screens/dependency_injection.dart';

HomeController homeController = Get.put(HomeController());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  DependencyInjection.init();

}

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(DevicePreview(
//       builder:  (context) => MyApp(),
//     enabled: true,
//   ));
//   DependencyInjection.init();
//
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      color: ConstColour.primaryColor,
      transitionDuration: const Duration(milliseconds: 500),
      // defaultTransition:Transition.rightToLeftWithFade,
      defaultTransition:Transition.cupertino,
      theme: ThemeData(splashColor: Colors.white,fontFamily: ConstFont.popinsRegular,focusColor: ConstColour.primaryColor,primaryColor: ConstColour.primaryColor,),

      home: SplashScreen(),
      // home: FeedBack(),
      // home: DemoApp(),

    );
  }
}
