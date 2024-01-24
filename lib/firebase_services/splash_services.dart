

 import 'dart:async';

import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/Screens/MainScreen/BottomBarScreen.dart';
import 'package:car_selling/Screens/MainScreen/HomeScreen.dart';
import 'package:car_selling/Screens/MainScreen/login_screen.dart';
import 'package:car_selling/Screens/MainScreen/introsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

 HomeController homeController = Get.put(HomeController());

class SplashServices {


  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;
    if(user != null ){
      Timer(const Duration(seconds: 3), () {
        checkPref();
        // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      });
    }
    Timer(const Duration(seconds: 3), () {

      Navigator.push(context, MaterialPageRoute(builder: (context) => const OnBoardingPage(),));

    });

 }


  checkPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("login") == true) {
      Get.to(() => BottomBarScreen() ,arguments: homeController.currentIndex = 0);

    } else {
      Get.to(() => const OnBoardingPage());
    }
  }

 }