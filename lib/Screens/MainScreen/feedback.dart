import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/Screens/MainScreen/BottomBarScreen.dart';
import 'package:car_selling/utils/utils.dart';
import 'package:car_selling/widgets/round_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ConstFile/constColors.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final fromKey = GlobalKey<FormState>();
  bool loading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    final deviceHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(

        appBar: AppBar(
          backgroundColor: ConstColour.primaryColor,
          centerTitle: true,
          title: Text("Feedback",
              style: TextStyle(fontFamily: ConstFont.popinsMedium)),
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.vertical,
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(
                  top: deviceHeight * 0.05, bottom: deviceHeight * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/Icons/appIcon.png",
                      width: deviceWidth * 0.7, fit: BoxFit.cover),
                  Text(
                    "F L Y I N G  C A R",
                    style: TextStyle(
                        fontSize: 22, fontFamily: ConstFont.ruwuduMedium),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.0),
              child: Text(
                "Fill Up Your Feedback",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: ConstFont.popinsMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: fromKey,
                  child: Column(children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        prefixIcon: Icon(Icons.supervised_user_circle),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.black,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.black,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.black,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            )),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Title";
                        } else if (value.length <= 2) {
                          return "Enter name minimum 4 character";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: desController,
                      minLines: 5,
                      maxLines: 7,
                      decoration: InputDecoration(
                          hintText: 'Description',
                          helperText: 'Write your feedback description',
                          prefixIcon: Icon(Icons.email_rounded),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: const BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.black,
                                strokeAlign: BorderSide.strokeAlignOutside,
                              ))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your feedback";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ])),
            )
          ]),
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: RoundButton(
                loading: loading,
                title: "Submit",
                onTap: () async {
                  if (fromKey.currentState!.validate()) {
                    setState(() {});
                    loading = true;
                    User? user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      loading = true;
                      debugPrint(user.uid);
                      debugPrint(user.email);
                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                      String userEmail = user.email.toString();
                      FirebaseFirestore.instance.collection("feedback").doc(userEmail).set({
                        'Email': userEmail,
                        'Title': titleController.text,
                        'Description': desController.text,
                      });
                      Utils().toastMessage("Feedback Submit Successfully");
                      loading = false;
                      Get.to(()=> const BottomBarScreen(),arguments: homeController.currentIndex = 0);
                    }
                  }
                }))

    );
  }}
