
import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/Screens/MainScreen/BottomBarScreen.dart';
import 'package:car_selling/Screens/MainScreen/HomeScreen.dart';
import 'package:car_selling/utils/utils.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


HomeController homeController = Get.put(HomeController());

class LoginController extends GetxController{


  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isHidden = true.obs;


  final _auth = FirebaseAuth.instance;

  void login(context){
      loading = true;
    _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("login", true);


      emailController.clear();
      passwordController.clear();
      Utils().toastMessage("Successfully Login : "+value.user!.email.toString());

      Get.to(() => BottomBarScreen() ,arguments: homeController.currentIndex = 0);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
      loading = false;
        final user = _auth.currentUser!.uid;
        debugPrint(_auth.currentUser!.uid);

      debugPrint(_auth.currentUser!.email);
        debugPrint(_auth.currentUser!.email);


    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
        loading = false;
    });
  }







}