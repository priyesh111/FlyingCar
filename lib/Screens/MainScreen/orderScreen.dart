import 'dart:math';
import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/Screens/MainScreen/BottomBarScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ConstFile/constColors.dart';
import 'HomeScreen.dart';

class CarModals {
  String? modal;
  String? image;
  String? price;
  String? varient;
  String? description;
  String? engine;
  String? maxpower;
  String? maxtorque;

  CarModals({
    required this.modal,
    required this.image,
    required this.price,
    required this.description,
    required this.engine,
    required this.maxpower,
    required this.maxtorque,
    required this.varient,
  });
}

class OrdersScreen extends StatefulWidget {
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  HomeController homeController = Get.put(HomeController());

  final _random = Random();


  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userEmail = user.email.toString();

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ConstColour.primaryColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text("Orders",
              style: TextStyle(
                fontFamily: ConstFont.popinsRegular,
                color: Colors.black87,
              )),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user_order')
              .doc(userEmail)
              .collection('order_items')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('You have no orders.'),
              );
            }

            List<CarModals> cartItems = snapshot.data!.docs.map((doc) {
              return CarModals(
                  image: doc['images'],
                  description: doc['descriptions'],
                  price: doc['price'],
                  modal: doc['modal'],
                  engine: doc['engine'],
                  maxpower: doc['maxpower'],
                  maxtorque: doc['maxtorque'],
                  varient: doc['varient']);
            }).toList();

            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              controller: ScrollController(),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                        side: BorderSide(color: Colors.black)),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Image.network(
                          cartItems[index].image.toString(),
                          width: deviceWidth * 0.7,
                          fit: BoxFit.fill,
                        )),
                        ListTile(
                          shape: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(11)),
                          tileColor: StickyColors.colors[_random.nextInt(10)],

                          title: Text('Model: ${cartItems[index].modal}',
                              style: TextStyle(
                                fontFamily: ConstFont.popinsMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1),
                          subtitle: Text('Price : ${cartItems[index].price}',
                              style: TextStyle(
                                fontFamily: ConstFont.popinsMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1),
                          // Add a button to remove the item from the cart if needed
                          // trailing: IconButton
                          //   (
                          //     splashColor: ConstColour.btnHowerColor,
                          //     onPressed: () {
                          //
                          // }, icon: Icon(Icons.delete_rounded,size: 26,color: Colors.black87,)),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_forever,size: 30,color: Colors.black,shadows: [Shadow(color: Colors.black54,blurRadius: deviceWidth * 0.2,)]),
                            onPressed: () {
                              // Remove the item from the cart
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    backgroundColor: ConstColour.bgColor,
                                title:  Row(
                                  children: [
                                    Text('Delete Order',style: TextStyle(color: ConstColour.primaryColor,fontFamily: ConstFont.popinsMedium,),),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.delete_forever,color: ConstColour.primaryColor),
                                    )
                                  ],
                                ),
                                content: const Text('Are you sure you want to delete this Order?',style: TextStyle(color: Colors.brown,fontFamily: ConstFont.popinsRegular)),
                                actions: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black
                                    ),
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel',style: TextStyle(color: Colors.white),),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black
                                    ),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('user_order')
                                          .doc(userEmail)
                                          .collection('order_items')
                                          .doc(snapshot.data!.docs[index].id)
                                          .delete();
                                      Navigator.pop(context, 'OK');
                                    },
                                    // onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK',style: TextStyle(color: Colors.white)),
                                  ),
                                ]
                                  ),
                              );
                              // FirebaseFirestore.instance
                              //     .collection('user_order')
                              //     .doc(userEmail)
                              //     .collection('order_items')
                              //     .doc(snapshot.data!.docs[index].id)
                              //     .delete();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      // Handle when the user is not authenticated
      return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        body: Center(
          child: Text('Please log in to view your orders.'),
        ),
      );
    }
  }
}
