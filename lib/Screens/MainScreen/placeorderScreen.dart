import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/cardetail_controller.dart';
import 'package:car_selling/Controllers/signup_controller.dart';
import 'package:car_selling/Screens/MainScreen/BottomBarScreen.dart';
import 'package:car_selling/Screens/MainScreen/billScreen.dart';
import 'package:car_selling/Screens/MainScreen/login_screen.dart';
import 'package:car_selling/Screens/MainScreen/orderScreen.dart';
import 'package:car_selling/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../ConstFile/constColors.dart';
import '../../Controllers/homeController.dart';
import '../../widgets/round_button.dart';

class PlaceOrder extends StatefulWidget {
  final String carCompany;

  PlaceOrder({required this.carCompany,});

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  CarDetailController carDetailController = Get.put(CarDetailController());
  HomeController homeController = Get.put(HomeController());


  bool loading = false;
  final fromKey = GlobalKey<FormState>();
  bool isDaily = false;

  var myFormat = DateFormat('d-MM-yyyy');
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ConstColour.primaryColor, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isDaily = true;
        debugPrint("Picked Date : " + picked.toString());
        debugPrint(
            "Selected Date : " + selectedDate.toString());
      });
    }
  }

  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  final mobileRegex = RegExp(r'^[0-9]{10}$');

  void disposeController(){
    carDetailController.varient.clear();
    carDetailController.price.clear();
    carDetailController.engine.clear();
    carDetailController.transmission.clear();
    carDetailController.modal.clear();
    carDetailController.images.clear();
    carDetailController.descriptions.clear();
    carDetailController.maxtorque.clear();
    carDetailController.maxpower.clear();
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    addressController.clear();
    passwordController.clear();
    cpasswordController.clear();
  }

  CollectionReference users = FirebaseFirestore.instance.collection("users");

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  RxBool isHidden = true.obs;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    String dropdownvalue = 'Cash On Delivery';

    // List of items in our dropdown menu
    var items = [
      'Cash On Delivery',
      'Comming soon other type'
    ];



    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColour.primaryColor,
        centerTitle: true,
        title: Text("Delivery",
            style: TextStyle(fontFamily: ConstFont.popinsMedium)),
      ),
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
                    "Fill Up Delivery Detail",
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
                    "   Set up your Name and Email & Address \n    You can always change it later.",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: ConstFont.popinsRegular,
                        color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ),
                Form(
                  key: fromKey,
                  child: Column(
                    children: [
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
                          } else if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          } else {
                            return null;
                          }
                        },
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
                      Card(
                        color: ConstColour.cardBgColor,
                        child: DropdownButton(
                          dropdownColor: ConstColour.cardBgColor,
                          focusColor: ConstColour.cardBgColor,
                          hint: Text("Select Payment Method"),
                          underline: SizedBox(),
                          // isDense: true,
                          isExpanded: true,
                          // Initial Value
                          value: dropdownvalue,
                          elevation: 24,
                          // Down Arrow Icon
                          icon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(Icons.keyboard_arrow_down),
                          ),

                          // Array list of items
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(items),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: deviceHeight * 0.01),
                        child: ListTile(
                          onTap: () {
                            _selectDate(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          tileColor: ConstColour.cardBgColor,
                          leading: const Icon(Icons.calendar_month),
                          minLeadingWidth: 0.0,
                          title: const Text(
                            "Select Delivery Date",
                            style: TextStyle(
                                fontFamily: ConstFont.popinsRegular,
                                fontSize: 12),
                          ),
                          dense: true,
                          subtitle: Text(
                            myFormat
                                .format(selectedDate),
                            style: const TextStyle(
                                fontFamily: ConstFont.popinsMedium,
                                fontSize: 12,
                                color: Colors.black),
                          ),
                          trailing: const Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Colors.black),
                        ),
                      ),

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
                CollectionReference userOrderCollection = firestore.collection('user_order');
                String userEmail = user.email.toString();
                String carModelToCheck = carDetailController.modal; // The car model you want to check

// Query the Firestore to check if the car model exists
              await userOrderCollection
                    .doc(userEmail)
                    .collection('order_items')
                    .where('modal', isEqualTo: carModelToCheck)
                    .get()
                    .then((QuerySnapshot querySnapshot) async {
                  if (querySnapshot.docs.isNotEmpty) {
                    // The car model exists, so the user has already bought it
                    Utils().toastMessage('You have already bought this car');
                    // showToast('You have already bought this car');
                  } else {

                    // The car model doesn't exist, so you can add it to the database


                    await FirebaseFirestore.instance
                        .collection('user_order')
                        .doc(userEmail).set({ 'ok':"testing",});


                    userOrderCollection
                        .doc(userEmail)
                        .collection('order_items')
                        .add({
                        'uId': user.uid,
                        'userEmail':user.email,
                        'Name': nameController.text,
                        'Email': emailController.text,
                        'Mobile': mobileController.text,
                        'Address': addressController.text,
                        'Type': dropdownvalue,
                        'Date': myFormat.format(selectedDate),
                        'carcompany' : widget.carCompany,
                        'modal': carDetailController.modal,
                        'engine': carDetailController.engine,
                        'maxpower': carDetailController.maxpower,
                        'maxtorque': carDetailController.maxtorque,
                        'price': carDetailController.price,
                        'descriptions': carDetailController.descriptions,
                        'transmission': carDetailController.transmission,
                        'images': carDetailController.images,
                        'varient': carDetailController.varient,
                    });
                    loading = false;
                    Get.to(() =>
                    BillScreen(nameController.text, emailController.text, addressController.text, mobileController.text, carDetailController.modal, carDetailController.price, myFormat.format(selectedDate))
                    );
                    disposeController();
                    // Get.to(()=> BottomBarScreen(),arguments: homeController.currentIndex = 2 );
                  }
                });

              } else {

              }



              // final user = await FirebaseAuth.instance.currentUser;
              // String id = user!.uid;
              // debugPrint(id.toString());
              // FirebaseFirestore.instance.collection("OrderDetail").doc(id).set({
              //   'uId': id.toString(),
              //   'Name': nameController.text,
              //   'Email': emailController.text,
              //   'Mobile': mobileController.text,
              //   'Address': addressController.text,
              //   'Type': dropdownvalue,
              //   'Date': myFormat.format(selectedDate)
              // });
              //
              // loading = false;
              // Get.to(() => OrdersScreen());
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
