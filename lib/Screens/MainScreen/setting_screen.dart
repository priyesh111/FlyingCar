import 'dart:math';

import 'package:car_selling/ConstFile/constColors.dart';
import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/Screens/MainScreen/BottomBarScreen.dart';
import 'package:car_selling/Screens/MainScreen/login_screen.dart';
import 'package:car_selling/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingScreen extends StatelessWidget {
  HomeController homeController = Get.put(HomeController());

  final _random = Random();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Orders",
              style: TextStyle(
                fontFamily: ConstFont.popinsRegular,
                color: Colors.black87,
              )),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            dense: true,
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(31),
                borderSide: BorderSide.none),
            tileColor: ConstColour.primaryColor,
            splashColor: Colors.deepPurpleAccent,
            // titleAlignment: ListTileTitleAlignment.center,
            title: Padding(
              padding: EdgeInsets.only(left: deviceWidth * 0.37),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: ConstFont.popinsMedium,
                  fontSize: 16,
                ),
              ),
            ),
            trailing:
                const Icon(Icons.exit_to_app, color: Colors.white, size: 26),
            onTap: () {
              auth.signOut().then((value) async {

                final SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setBool("login", false);
                Get.to(() => LoginScreen());
                Utils().toastMessage("Successfully Logout");

              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
          ),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('User not found.');
            }

            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text("User Details",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: ConstFont.ruwuduMedium)),
                  ),
                  Center(
                    child: Card(
                      color: Colors.black87,
                      elevation: 2.0,
                      shape:
                          CircleBorder(side: BorderSide(color: Colors.black)),
                      child: CircleAvatar(
                        child: Image.asset("assets/Images/boy.gif"),
                        minRadius: 30,
                        maxRadius: 50,
                        backgroundColor: Colors.black87,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: deviceWidth * 0.02,
                      top: deviceHeight * 0.01,
                    ),
                    child: Text('Name: ${userData['Name']}',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: ConstFont.popinsMedium,
                            fontSize: 18),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: deviceWidth * 0.02,
                      top: deviceHeight * 0.01,
                    ),
                    child: Text(
                      'Address: ${userData['Address']}',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: ConstFont.popinsMedium,
                          fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: deviceWidth * 0.02,
                      top: deviceHeight * 0.01,
                    ),
                    child: Text('Email: ${userData['Email']}',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: ConstFont.popinsMedium,
                            fontSize: 18),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: deviceWidth * 0.02,
                      top: deviceHeight * 0.01,
                    ),
                    child: Text('Mobile No: ${userData['Mobile']}',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: ConstFont.popinsMedium,
                            fontSize: 18),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else {
      // Handle when the user is not authenticated
      return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: Center(
          child: Text('Please log in to view your Details.'),
        ),
      );
    }
  }
}
