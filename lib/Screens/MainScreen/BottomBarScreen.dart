import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/Screens/MainScreen/HomeScreen.dart';
import 'package:car_selling/Screens/MainScreen/cart.dart';
import 'package:car_selling/Screens/MainScreen/orderScreen.dart';
import 'package:car_selling/Screens/MainScreen/splash.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ConstFile/constColors.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {







  final screens = [HomeScreen(),CartScreen(),OrdersScreen()];

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: homeController.currentIndex,

        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,

        selectedLabelStyle: TextStyle(
          fontFamily: ConstFont.popinsMedium,
          color: Colors.black, ),
        items: [
          BottomNavigationBarItem(
              label: "Home",
              backgroundColor: Colors.black87,
              icon: Icon(CupertinoIcons.home,
                  color: homeController.currentIndex == 0
                      ? ConstColour.primaryColor
                      : Colors.black)
          ),
          BottomNavigationBarItem(
              label: "Cart",
              icon: Icon(Icons.shopping_cart,
                  size: 26,
                  color: homeController.currentIndex == 1
                      ? ConstColour.primaryColor
                      : Colors.black)),
          BottomNavigationBarItem(
              label: "Order",
              icon: Icon(Icons.shopping_bag_sharp,
                  size: 26,
                  color: homeController.currentIndex == 2
                      ? ConstColour.primaryColor
                      : Colors.black)),

        ],
        onTap: (value) {
          setState(() {
            homeController.currentIndex = value;
          });


        },
      ),
      body: IndexedStack(
        index: homeController.currentIndex,
        children: screens,
      ),

    );
  }
}
