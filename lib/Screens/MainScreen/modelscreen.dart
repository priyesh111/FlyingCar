import 'dart:math';
import 'package:car_selling/ConstFile/constColors.dart';
import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Screens/MainScreen/car_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarModal{

  String? name;
  String? image;
  String? price;
  String? varient;
  String? description;
  String? engine;
  String? maxpower;
  String? maxtorque;

  CarModal({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.engine,
    required this.maxpower,
    required this.maxtorque,
    required this.varient,
  });
}

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

class CarModelsScreen extends StatelessWidget {
  final String carCompany;

  CarModelsScreen({required this.carCompany});

  final _random = Random();

  @override
  Widget build(BuildContext context) {

    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColour.primaryColor,
        centerTitle: true,
        title: Text(carCompany,style: TextStyle(fontFamily: ConstFont.popinsMedium)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('motar')
            .doc(carCompany)
            .collection('models')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final List<DocumentSnapshot> carModels = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: carModels.length,
            itemBuilder: (context, index) {
              final carModel = carModels[index];
              debugPrint(carModels[index]['modal'].toString());
              // debugPrint(carModels[index]['image'].toString());
              debugPrint(carModels[index]['maxpower'].toString());
              debugPrint(carModels[index]['maxtorque'].toString());
              debugPrint(carModels[index]['price'].toString());
              debugPrint(carModels[index]['varient'].toString());

              // testController.carmodalList.addAll(carModel.to);

              return Padding(
                padding:  EdgeInsets.only(left: deviceWidth * 0.03,right: deviceWidth * 0.03,top: deviceHeight * 0.01,bottom: 0.01),
                child: GestureDetector(
                   onTap: () {
                     // Get.to(() => CarModel(carCompany: carCompany,indexes: index,));
                     Get.to(() => CarDetailScreen(indexes: index,carCompany: carCompany,));
                   },
                  child: Card(
                    color:StickyColors.colors[_random.nextInt(10)],
                    shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(11),
                           side: BorderSide(color: Colors.black12)
                     ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(carModel['image'].toString(),fit: BoxFit.contain),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(carModels[index]['modal'].toString(),style: TextStyle(fontSize: 16,fontFamily: ConstFont.popinsMedium),),
                  Container(
                                              width: deviceWidth * 0.08,
                                              height: deviceHeight * 0.025,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: ConstColour.primaryColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    // offset: Offset(0, 3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: InkWell(
                                                  onTap: () {},
                                                  child: Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.white,
                                                    size: deviceWidth * 0.04,
                                                  ))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
