import 'package:car_selling/ConstFile/constColors.dart';
import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/cardetail_controller.dart';
import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/Screens/MainScreen/BottomBarScreen.dart';
import 'package:car_selling/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'placeorderScreen.dart';

class CarDetailScreen extends StatefulWidget {
  final String carCompany;
  final int indexes;
  CarDetailScreen({required this.carCompany, required this.indexes});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  HomeController homeController = Get.put(HomeController());

  CarDetailController carDetailController = Get.put(CarDetailController());

  // final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // backgroundColor: ConstColour.bgColor,
      appBar: AppBar(
        backgroundColor: ConstColour.primaryColor,
        centerTitle: true,
        title: Text(widget.carCompany,
            style: TextStyle(fontFamily: ConstFont.popinsMedium)),
      ),
      backgroundColor: Colors.orange.shade50,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            bottom: deviceHeight * 0.01,
            top: deviceHeight * 0.01,
            left: deviceWidth * 0.02,
            right: deviceWidth * 0.02),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(3)),
                    backgroundColor: Color(0xff99CE02),
                    minimumSize: Size(deviceWidth * 0.4, deviceHeight * 0.06),
                    maximumSize: Size(deviceWidth * 0.6, deviceHeight * 0.06),
                    elevation: 0.5),
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;

                  if (user != null) {

                    debugPrint(user.uid);
                    debugPrint(user.email);
                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    CollectionReference userOrderCollection = firestore.collection('user_carts');
                    String userEmail = user.email.toString();
                    String carModelToCheck = carDetailController.modal; // The car model you want to check

// Query the Firestore to check if the car model exists
                    userOrderCollection
                        .doc(userEmail)
                        .collection('cart_items')
                        .where('modal', isEqualTo: carModelToCheck)
                        .get()
                        .then((QuerySnapshot querySnapshot) async {
                      if (querySnapshot.docs.isNotEmpty) {
                        // The car model exists, so the user has already bought it
                        Utils().toastMessage('You have already AddToCart car');
                        // showToast('You have already bought this car');
                      } else {
                        // The car model doesn't exist, so you can add it to the database
                        await FirebaseFirestore.instance
                              .collection('user_carts')
                              .doc(userEmail).set({ 'ok':"testing",});

                        userOrderCollection
                            .doc(userEmail)
                            .collection('cart_items')
                            .add({
                          'modal': carDetailController.modal,
                          'carcompany' : widget.carCompany,
                          'engine': carDetailController.engine,
                          'maxpower': carDetailController.maxpower,
                          'maxtorque': carDetailController.maxtorque,
                          'price': carDetailController.price,
                          'descriptions': carDetailController.descriptions,
                          'transmission': carDetailController.transmission,
                          'images': carDetailController.images,
                          'varient': carDetailController.varient,
                        });

                        Get.to(()=> BottomBarScreen(),arguments: homeController.currentIndex = 1);
                      }
                    });




                  } else {

                  }
                },
                child: Text(
                  "Add To Cart",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: ConstFont.popinsMedium),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.02,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(3)),
                    backgroundColor: Color(0xffFF8C1A),
                    minimumSize: Size(deviceWidth * 0.4, deviceHeight * 0.06),
                    maximumSize: Size(deviceWidth * 0.6, deviceHeight * 0.06),
                    elevation: 0.5),
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
//
                  if (user != null) {
                    debugPrint(user.uid);
                    debugPrint(user.email);
                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    CollectionReference userOrderCollection = firestore
                        .collection('user_order');
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
                        Utils().toastMessage(
                            'You have already bought this car');
                        // showToast('You have already bought this car');
                      } else {
                        // The car model doesn't exist, so you can add it to the database
                        Get.to(() => PlaceOrder(carCompany: widget.carCompany));


                        // await FirebaseFirestore.instance
                        //     .collection('user_order')
                        //     .doc(userEmail).set({ 'ok': "testing",});
                        //
                        //
                        // userOrderCollection
                        //     .doc(userEmail)
                        //     .collection('order_items')
                        //     .add({
                        //   'modal': carDetailController.modal,
                        //   'engine': carDetailController.engine,
                        //   'maxpower': carDetailController.maxpower,
                        //   'maxtorque': carDetailController.maxtorque,
                        //   'price': carDetailController.price,
                        //   'descriptions': carDetailController.descriptions,
                        //   'transmission': carDetailController.transmission,
                        //   'images': carDetailController.images,
                        //   'varient': carDetailController.varient,
                        // });
                        //
                        // Get.to(() => BottomBarScreen(), arguments:
                        // homeController.currentIndex = 2);
                      }
                    });
                  }
                  // } else {
//
//                   }
                },
                child: Text(
                  "Buy Now",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: ConstFont.popinsMedium),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('motar')
                    .doc(widget.carCompany)
                    .collection('models')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  if (snapshot.hasError) return Text(("Some Error"));

                  final List<DocumentSnapshot> carModels = snapshot.data!.docs;
                  return ListView.builder(
                    controller: ScrollController(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      index = widget.indexes;
                      final carModel = carModels[index];

                      carDetailController.modal = carModels[index]['modal'].toString();
                      carDetailController.engine = carModels[index]['engine'].toString();
                      carDetailController.maxpower = carModels[index]['maxpower'].toString();
                      carDetailController.descriptions = carModels[index]['description'].toString();
                      carDetailController.varient = carModels[index]['varient'].toString();
                      carDetailController.maxtorque = carModels[index]['maxtorque'].toString();
                      carDetailController.price = carModels[index]['price'].toString();
                      carDetailController.transmission = carModels[index]['transmission'].toString();
                      carDetailController.images = carModels[index]['image'].toString();

                      debugPrint(carDetailController.modal);
                      debugPrint(carDetailController.images);
                      debugPrint(carDetailController.transmission);
                      debugPrint(carDetailController.descriptions);
                      debugPrint(carDetailController.maxtorque);
                      debugPrint(carDetailController.price);
                      debugPrint(carDetailController.varient);
                      debugPrint(carDetailController.maxpower);
                      debugPrint(carDetailController.engine);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Container(
                                  width: deviceWidth * 0.9,
                                  height: deviceHeight * 0.3,
                                  child: Image.network(
                                      carModel['image'].toString())),
                            ),
                          ),
                          Text(
                            carModels[index]['modal'].toString(),
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: ConstFont.popinsMedium),
                          ),
                          Text(
                            "₹ " + carModels[index]['price'].toString(),
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: ConstFont.popinsMedium),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              // color: ConstColour.cardBgColor,
                              child: Container(
                                  // width: deviceWidth * 0.9,
                                  // height: deviceHeight * 0.3,
                                  child: Column(
                                children: [
                                  ListTile(
                                      leading: Image.asset(
                                          "assets/Images/engine.gif",
                                          width: deviceWidth * 0.1),
                                      title: Text(
                                        "Engine Type : " +
                                            carModels[index]['engine']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily:
                                                ConstFont.popinsRegular),
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  ListTile(
                                      leading: Image.asset(
                                          "assets/Images/speedometer.gif",
                                          width: deviceWidth * 0.1),
                                      title: Text(
                                        "Max Power : " +
                                            carModels[index]['maxpower']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily:
                                                ConstFont.popinsRegular),
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  ListTile(
                                      leading: Image.asset(
                                          "assets/Images/torque-wrench.png",
                                          width: deviceWidth * 0.08),
                                      title: Text(
                                        "Max Torque : " +
                                            carModels[index]['maxtorque']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily:
                                                ConstFont.popinsRegular),
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  ListTile(
                                      leading: Image.asset(
                                          "assets/Images/gear-shift.png",
                                          width: deviceWidth * 0.08),
                                      title: Text(
                                        "Transmission : " +
                                            carModels[index]['transmission']
                                                .toString(),
                                        style: TextStyle(
                                            fontFamily:
                                                ConstFont.popinsRegular),
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ],
                              )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ExpandablePanel(
                                controller:
                                    ExpandableController(initialExpanded: true),
                                theme: ExpandableThemeData(
                                    // alignment: Alignment.center,

                                    hasIcon: true,
                                    iconSize: 24,
                                    fadeCurve: Curves.slowMiddle,
                                    iconPadding: EdgeInsets.only(
                                        top: deviceHeight * 0.02,
                                        right: deviceWidth * 0.02)),
                                header: Padding(
                                  padding: EdgeInsets.only(
                                      top: deviceHeight * 0.025,
                                      left: deviceWidth * 0.04),
                                  child: const Text("Car Description",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: ConstFont.popinsRegular)),
                                ),
                                collapsed: const Text(
                                  "",
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                expanded: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    carModels[index]['description'].toString(),
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: ConstFont.popinsRegular),
                                  ),
                                ),
                                // tapHeaderToExpand: true,
                                // hasIcon: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              // color: ConstColour.cardBgColor,
                              child: Container(
                                  // width: deviceWidth * 0.9,
                                  // height: deviceHeight * 0.3,
                                  child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      "Varient : " +
                                          carModels[index]['varient']
                                              .toString(),
                                      style: TextStyle(
                                          fontFamily: ConstFont.popinsRegular),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              )),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
