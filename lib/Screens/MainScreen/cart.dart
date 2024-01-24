import 'dart:math';

import 'package:car_selling/ConstFile/constColors.dart';
import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/Screens/MainScreen/cartmodel_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controllers/cardetail_controller.dart';

class StickyColors {
  static final List colors = [
    Color(0xffF1F7E6),
    Color(0xffF4F5F0),
    Color(0xffF2DAC1),
    Color(0xffF8EEEC),
    Color(0xffFFF7E7),
    Color(0xffEDF4FA),
    Color(0xffFBFBF9),
    Color(0xffEEE8E6),
    Color(0xffFFF2D0),
    Color(0xffE6DBAC),
    Color(0xffEDE8BA),
    Color(0xffFDEFB2),
    Color(0xffF8F8E8),
    Color(0xffF2F7FD),
    Color(0xffFDEFB2),
    Color(0xffFEC5E5),


  ];
}


class CarModal{
  String? modal;
  String? carcompany;
  String? transmission;
  String? image;
  String? price;
  String? varient;
  String? description;
  String? engine;
  String? maxpower;
  String? maxtorque;

  CarModal({
    required this.modal,
    required this.image,
    required this.price,
    required this.description,
    required this.engine,
    required this.maxpower,
    required this.maxtorque,
    required this.varient,
    required this.transmission,
    required this.carcompany,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  final _random = Random();

  HomeController homeController = Get.put(HomeController());
  CarDetailController carDetailController = Get.put(CarDetailController());



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
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
            title: Text(
                "Cart",style: TextStyle(
              fontFamily: ConstFont.popinsRegular,
              color: Colors.black87,)),
          ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
          Card(
            color: ConstColour.cardBgColor,
                  child: ListTile(
                    leading: Image.asset("assets/Images/ecocar.gif"),
                    title: Text(
                        "Add to cart other cars",style: TextStyle(
                      fontFamily: ConstFont.popinsRegular,
                      color: Colors.black87,)),
                  ),
                ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user_carts')
                    .doc(userEmail)
                    .collection('cart_items')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('Your cart is empty.'),
                    );
                  }

                  List<CarModal> cartItems = snapshot.data!.docs.map((doc) {
                    return CarModal(
                        image: doc['images'],
                        description: doc['descriptions'],
                        price: doc['price'],
                        modal: doc['modal'],
                        engine: doc['engine'],
                        maxpower: doc['maxpower'],
                        maxtorque: doc['maxtorque'],
                        varient: doc['varient'],
                        transmission: doc['transmission'],
                        carcompany: doc['carcompany'],
                    );
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
                            side: BorderSide(color: Colors.black)
                          ),
                      color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Image.network(
                                cartItems[index].image.toString(),width: deviceWidth * 0.7,fit: BoxFit.fill,)),
                              ListTile(
                                 onTap: () {
                                   carDetailController.modal = cartItems[index].modal;
                                   Get.to( () => CartModelScreen(carCompany: cartItems[index].carcompany.toString(), indexes: index));
                                 },
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(11)
                                ),
                                tileColor:StickyColors.colors[_random.nextInt(10)],

                                title: Text('Model: ${cartItems[index].modal}',style: TextStyle(fontFamily: ConstFont.popinsMedium,overflow: TextOverflow.ellipsis,),maxLines: 1),
                                subtitle: Text('Price : ${cartItems[index].price}',style: TextStyle(fontFamily: ConstFont.popinsMedium,overflow: TextOverflow.ellipsis,),maxLines: 1),

                                trailing: IconButton(
                                  icon: Icon(Icons.delete_forever,size: 30,color: Colors.black,shadows: [Shadow(color: Colors.black54,blurRadius: deviceWidth * 0.2,)]),
                                  onPressed: () {
                                    // Remove the item from the cart
                                    FirebaseFirestore.instance
                                        .collection('user_carts')
                                        .doc(userEmail)
                                        .collection('cart_items')
                                        .doc(snapshot.data!.docs[index].id)
                                        .delete();
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
            ],
          ),
        ),
      );
    } else {
      // Handle when the user is not authenticated
      return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: Center(
          child: Text('Please log in to view your cart.'),
        ),
      );
    }
  }
}
