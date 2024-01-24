import 'package:car_selling/ConstFile/constColors.dart';
import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/login_controller.dart';
import 'package:car_selling/Screens/MainScreen/splash.dart';
import 'package:car_selling/widgets/round_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  LoginController loginController = Get.put(LoginController());

  final fromKey = GlobalKey<FormState>();


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginController.emailController.clear();
    loginController.passwordController.clear();
  }

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();





  final passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');


  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: ConstColour.bgColor,
        // appBar: AppBar(
        //   title: const Text("Login"),
        //   centerTitle: true,
        // ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
          child: SafeArea(
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                children: [

              Padding(
                padding:  EdgeInsets.only(top: deviceHeight * 0.1,bottom: deviceHeight * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/Icons/appIcon.png",width: deviceWidth * 0.7,fit: BoxFit.cover),
                    const Text("F L Y I N G  C A R",style: TextStyle(
                        fontSize: 22,
                        fontFamily: ConstFont.ruwuduMedium
                        
                    ),),
                  ],
                ),
              ),
                  const Text("Welcome Back",style: TextStyle(
                      fontSize: 24,
                      fontFamily: ConstFont.popinsMedium,
                    fontWeight: FontWeight.w600,
                  ),),
                  Padding(
                    padding:  EdgeInsets.only(bottom: deviceHeight * 0.05),
                    child: Text("Login into your account using email\n                  or social networks ",style: TextStyle(
                      fontSize: 16,
                      fontFamily: ConstFont.popinsRegular,
                      color: Colors.grey.shade600
                    ),),
                  ),
                  Form(
                    key: fromKey,
                    autovalidateMode:  AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          autocorrect:true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autofillHints: Characters(AutofillHints.email),
                          keyboardType: TextInputType.emailAddress,
                          controller: loginController.emailController,
                          decoration:  InputDecoration(
                            hintText: 'Email',
                            helperText: 'Enter Email e.g jon@gmail.com',
                            prefixIcon: const Icon(Icons.email_rounded),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: const BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.black,
                                strokeAlign: BorderSide.strokeAlignOutside,
                              ),
                            ),
                            border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(color: Colors.black)
                            )
                          ),


                          validator: (value) {
                              if(value!.isEmpty){
                                return "Enter Email";

                              }else  if (!emailRegex.hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              else{
                                return null;
                              }
                          },
                        ),
                        SizedBox(height: deviceHeight * 0.01,),
                        TextFormField(
                          autocorrect:true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autofillHints: Characters(AutofillHints.password),
                          keyboardType: TextInputType.visiblePassword,
                          controller: loginController.passwordController ,
                          obscureText: loginController.isHidden.value,
                          decoration:  InputDecoration(
                              hintText: 'Password',
                            helperText: 'Enter Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                loginController.isHidden.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              color: ConstColour.primaryColor,
                              onPressed: () {
                                setState(() {
                                  loginController.isHidden.value =! loginController.isHidden.value;
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
                              )
                            )

                          ),

                          validator: (value) {
                            if(value!.isEmpty){
                              return "Enter Password";
                            }else if (!passwordRegex.hasMatch(value)) {
                              return 'Password must be at least 8 characters and contain letters and numbers';
                            }
                            else{
                              return null;
                            }
                          },
                        ),


                      ],
                    ),
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     TextButton(onPressed: () {
                  //
                  //     }, child: const Text("Forgot Password?",style: TextStyle(
                  //         fontSize: 14,
                  //         fontFamily: ConstFont.popinsRegular,
                  //         color: ConstColour.primaryColor
                  //     ),),),
                  //   ],
                  // ),

                  Padding(
                    padding:  EdgeInsets.only(top: deviceHeight * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?",style: TextStyle(
                            fontSize: 14,
                            fontFamily: ConstFont.popinsRegular,
                        )),
                        TextButton(onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),));
                        }, child: const Text("Sign up",style: TextStyle(
                            fontSize: 14,
                            fontFamily: ConstFont.popinsRegular,
                            color: ConstColour.primaryColor
                        )))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:  Padding(
          padding: const EdgeInsets.all(28.0),
          child: RoundButton(loading: loginController.loading, title: "Login",onTap: () {
            if(fromKey.currentState!.validate()){

              setState(() {
                loginController.login(context);
              });
            }
          },),
        ),
      ),
    );
  }
}
