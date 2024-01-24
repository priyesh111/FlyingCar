

import 'package:car_selling/Screens/MainScreen/login_screen.dart';
import 'package:car_selling/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';


class SignUpController extends GetxController{


  bool loading = false;
  final fromKey = GlobalKey<FormState>();
  RxBool isHidden = true.obs;


}