import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/signup_controller.dart';
import 'package:car_selling/Screens/MainScreen/login_screen.dart';
import 'package:car_selling/Screens/MainScreen/splash.dart';
import 'package:car_selling/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../ConstFile/constColors.dart';
import '../../widgets/round_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpController signUpController = Get.put(SignUpController());

  bool loading = false;
  final fromKey = GlobalKey<FormState>();

  CollectionReference users = FirebaseFirestore.instance.collection("users");

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  RxBool isHidden = true.obs;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  final mobileRegex = RegExp(r'^[0-9]{10}$');
  final passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');



  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    "Create Your Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: ConstFont.popinsMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: deviceHeight * 0.05),
                  child: Text(
                    "   Set up your username and password. \n         You can always change it later.",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: ConstFont.popinsRegular,
                        color: Colors.grey.shade600),
                  ),
                ),
                Form(
                  key: fromKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Name',
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
                            return "Enter Your Name";
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
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            helperText: 'Enter Email e.g jon@gmail.com',
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
                            return "Enter Your Email";
                          } else if (!emailRegex.hasMatch(value!)) {
                            return 'Enter a valid email address';
                          } else {
                            return null;
                          }
                        },
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "Enter Your Email";
                        //   } else if (value.isNumericOnly) {
                        //     return "Please enter valid email";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: mobileController,
                        maxLength: 10,
                        decoration: InputDecoration(
                            hintText: 'Mobile No',
                            prefixIcon: Icon(Icons.call),
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
                            return "Enter Your Mobile Number";
                          } else if (!mobileRegex.hasMatch(value)) {
                            return 'Enter a valid 10-digit mobile number';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                            hintText: 'Address',
                            prefixIcon: Icon(Icons.home),
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
                            return "Enter Your Address";
                          } else if (value.length <= 5) {
                            return "Enter full address";
                          } else {
                            return null;
                          }
                        },
                      ),

                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: passwordController,
                        obscureText: signUpController.isHidden.value,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              signUpController.isHidden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            color: ConstColour.primaryColor,
                            onPressed: () {
                              setState(() {
                                signUpController.isHidden.value =
                                    !signUpController.isHidden.value;
                              });
                            },
                          ),
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
                          hintText: 'Password',
                          helperText: 'Enter Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          } else if (!passwordRegex.hasMatch(value)) {
                            return 'Password must be at least 8 characters and contain letters and numbers';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: cpasswordController,
                        obscureText: signUpController.isHidden.value,
                        decoration: InputDecoration(
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              signUpController.isHidden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            color: ConstColour.primaryColor,
                            onPressed: () {
                              setState(() {
                                signUpController.isHidden.value =
                                    !signUpController.isHidden.value;
                              });
                            },
                          ),
                          hintText: 'Confirm Password',
                          helperText: 'Enter Your Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Confirm Password";
                          } else if (!passwordRegex.hasMatch(value)) {
                            return 'Password must be at least 8 characters and contain letters and numbers';
                          } else if (value != passwordController.text) {
                            return 'Password doesn\'t Match';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: ConstFont.popinsRegular,
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ));
                          },
                          child: const Text("Login",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: ConstFont.popinsRegular,
                              )))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(28.0),
        child: RoundButton(
          loading: loading,
          title: "SignUp",
          onTap: () async {
            if (fromKey.currentState!.validate()) {
              setState(() {});
              try {
                loading = true;
                final credential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text);
              } on FirebaseAuthException catch (e) {
                loading = false;
                if (e.code == "Weak Password") {
                  debugPrint("The password provided is too weak");
                } else if (e.code == 'email-already-in-use') {
                  debugPrint("The account already exists for that email");
                  Utils().toastMessage(
                      "The account already exists for that email try again");
                } else {}
              } catch (e) {
                loading = false;
                debugPrint(e.toString());
              }

              final user = await FirebaseAuth.instance.currentUser;
              String id = user!.uid;
              debugPrint(id.toString());
              FirebaseFirestore.instance.collection("users").doc(id).set({
                'uId': id.toString(),
                'Name': nameController.text,
                'Email': emailController.text,
                'Mobile': mobileController.text,
                'Address': addressController.text,
                'Password': passwordController.text
              });

              loading = false;
              Get.to(() => LoginScreen());
              setState(() {});
            } else {
              loading = false;
              Utils().toastMessage("Enter The Value");
              setState(() {});
            }
          },
        ),
      ),
    );
  }
}
