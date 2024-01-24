import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/Screens/MainScreen/BottomBarScreen.dart';
import 'package:car_selling/Screens/MainScreen/setting_screen.dart';
import 'package:car_selling/Screens/MainScreen/login_screen.dart';
import 'package:car_selling/utils/utils.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feedback.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  HomeController homeController = Get.put(HomeController());


  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            curve: Curves.bounceInOut,
            child: Column(
              children: [
                const Text("User Details",
                    style: TextStyle(
                        fontSize: 16, fontFamily: ConstFont.ruwuduMedium)),
                Card(
                  color: Colors.black87,
                  elevation: 2.0,
                  shape: const CircleBorder(side: BorderSide(color: Colors.black)),
                  child: CircleAvatar(
                    child: Image.asset("assets/Images/boy.gif"),
                    minRadius: 30,
                    maxRadius: 50,
                    backgroundColor: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            splashColor: Colors.deepPurpleAccent,
            title: const Text(
              'Settings',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: ConstFont.popinsMedium),
            ),
            leading: const Icon(Icons.settings, color: Colors.black),
            onTap: () {
                Get.to(() => SettingScreen());
            },
          ),
          ListTile(
            splashColor: Colors.deepPurpleAccent,
            title: const Text(
              'Dark Mode',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: ConstFont.popinsMedium),
            ),
            leading: const Icon(Icons.brightness_medium, color: Colors.black),
            onTap: () {
              setState(() {
                Get.isDarkMode
                    ? Get.changeTheme(ThemeData.light())
                    : Get.changeTheme(ThemeData.dark());
              });
            },
          ),
          ListTile(
            splashColor: Colors.deepPurpleAccent,
            title: const Text(
              'Feedback',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            leading: const Icon(Icons.star_purple500, color: Colors.black),
            onTap: () {
              Get.to(() => const FeedBack());
            },
          ),
          ListTile(
            splashColor: Colors.deepPurpleAccent,
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            leading: const Icon(Icons.exit_to_app, color: Colors.black),
            onTap: () {
              auth.signOut().then((value) async {
                final SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setBool("login", false);

                Get.to(() => const LoginScreen());
                Utils().toastMessage("Successfully Logout");

              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
          ),
        ],
      ),
    );
  }
}
