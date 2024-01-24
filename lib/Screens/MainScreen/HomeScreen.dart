import 'dart:math';
import 'package:car_selling/ConstFile/constColors.dart';
import 'package:car_selling/ConstFile/constFonts.dart';
import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/Screens/MainScreen/modelscreen.dart';
import 'package:car_selling/Screens/MainScreen/custom_drawer_home_screen.dart';
import 'package:car_selling/Screens/MainScreen/splash.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';
import 'login_screen.dart';

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


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {








  HomeController homeController = Get.put(HomeController());

  final auth = FirebaseAuth.instance;
  // final cars = FirebaseFirestore.instance.collection("cars").snapshots();
  final cars = FirebaseFirestore.instance.collection("company").snapshots();
  final CollectionReference imagesCollection = FirebaseFirestore.instance.collection('slider');
  final CollectionReference companyCollection = FirebaseFirestore.instance.collection('cars');



  final _random = Random();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;


    debugPrint("rebuild");
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: ConstColour.bgColor,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: ConstColour.primaryColor,
          title: Text("Dashboard",style: TextStyle(color: Colors.black,fontFamily: ConstFont.popinsMedium,fontSize: 18)),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: ConstColour.cardBgColor,
                child: ListTile(
                  dense: true,
                  leading: Image.asset("assets/Images/jeep.gif"),
                  title: Text(
                      "Find the perfact car for you.",style: TextStyle(
                    fontFamily: ConstFont.popinsMedium,
                    fontSize: 14,
                    color: Colors.black87,)),
                  subtitle: Text(
                      "Seamlessly browse thousands of MRL Certified cars.",style: TextStyle(
                    fontFamily: ConstFont.popinsRegular,
                    fontSize: 12,
                    color: Colors.black54,)),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     // controller: searchFilter,
              //     decoration: InputDecoration(
              //         hintText: "Search",
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(11))),
              //     onChanged: (value) {
              //       // setState(() {
              //         // searchFilter.text = value;
              //       // });
              //       // initSearchingCompany(value);
              //       // initSearchingCompany(searchFilter.text);
              //     },
              //   ),
              // ),

          StreamBuilder<QuerySnapshot>(
            stream: imagesCollection.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(); // Loading indicator
              }
              final documents = snapshot.data!.docs;

              return CarouselSlider(
                items: documents.map((doc) {
                  final imageUrl = doc['image'] as String;
                  return Container(
                    margin: EdgeInsets.all(5.0),
                    child: Image.network(imageUrl),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200, // Adjust the height as needed
                  aspectRatio: 14 / 8,
                  viewportFraction: 0.8,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 2),
                  autoPlayAnimationDuration: Duration(milliseconds: 2000),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                ),
              );
            },
          ),


              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: CarouselSlider(
              //     options: CarouselOptions(
              //       aspectRatio: 2.0,
              //       enlargeCenterPage: true,
              //       enableInfiniteScroll: true,
              //       initialPage: 2,
              //       autoPlay: true,
              //     ),
              //     items: homeController.imgList
              //         .map((item) => Center(
              //         child: Image.asset(item,
              //             fit: BoxFit.cover, width: 1000)))
              //         .toList(),
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color:StickyColors.colors[_random.nextInt(10)],

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Select your perfact Car",style: TextStyle(
                      fontFamily: ConstFont.popinsMedium,
                      fontSize: 20,
                      color: Colors.black,),textAlign: TextAlign.center),
                  ),
                ),
              ),

              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('motar').snapshots(),
                  builder: ( context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    if(snapshot.hasError)
                      return Center(child: Text(("Some Error")));
                    final List<DocumentSnapshot> carCompanies = snapshot.data!.docs;


                    return GridView.builder(
                      controller: ScrollController(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // crossAxisSpacing: 1,
                          // mainAxisSpacing: 5,
                          mainAxisExtent: 140,
                      ),
                      itemCount: carCompanies.length,
                      itemBuilder: (context, index) {
                        final carCompany = carCompanies[index];

                        return InkWell(
                          onTap: () {
                            // testController.carName= index;
                            // testController.companyName = snapshot.data!.docs[index]['company'].toString();
                            // debugPrint(testController.carName.toString());
                            //    Get.to(()=> TestScreen());

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarModelsScreen(carCompany: carCompany.id),
                              ),
                            );
                          },
                          splashColor: ConstColour.btnHowerColor,
                          child: Card(
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(21)
                            ),
                            // color: ConstColour.cardBgColor,
                            color:StickyColors.colors[_random.nextInt(10)],
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: deviceHeight * 0.02),
                                child: Image.network(carCompany['companyLogo'],width : deviceWidth * 0.2),
                              ),
                              Card(
                                  child: Padding(
                                padding: EdgeInsets.only(left: deviceWidth * 0.01,right: deviceWidth * 0.01),
                                child: Text(carCompany.id,style: TextStyle(fontFamily: ConstFont.popinsMedium,)),
                              )),
                            ],
                          ),
                          ),
                        );

                      },
                    );
                  }
              ),
              StreamBuilder<QuerySnapshot>(
                stream: companyCollection.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(); // Loading indicator
                  }
                  final documents = snapshot.data!.docs;

                  return CarouselSlider(
                    items: documents.map((doc) {
                      final imageUrl = doc['image'] as String;
                      return Container(
                        margin: EdgeInsets.all(5.0),
                        child: Image.network(imageUrl,width: deviceWidth * 0.3),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 150, // Adjust the height as needed
                      aspectRatio: 12 / 6,
                      viewportFraction: 0.8,
                      autoPlay: true,
                      initialPage: 3,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 3000),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                    ),
                  );
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: CarouselSlider(
              //     options: CarouselOptions(
              //       aspectRatio: 2.0,
              //       enlargeCenterPage: true,
              //       enableInfiniteScroll: true,
              //       initialPage: 2,
              //       autoPlay: true,
              //     ),
              //     items: homeController.imgListtwo
              //         .map((item) => Center(
              //         child: Image.asset(item,
              //             fit: BoxFit.cover, width: 1000)))
              //         .toList(),
              //   ),
              // ),
























              // StreamBuilder<QuerySnapshot>(
              //     stream: cars,
              //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting)
              //         return CircularProgressIndicator();
              //       if(snapshot.hasError)
              //         return Text(("Some Error"));
              //       return GridView.builder(
              //         controller: ScrollController(),
              //         scrollDirection: Axis.vertical,
              //         shrinkWrap: true,
              //         gridDelegate:
              //         SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 2,
              //             // crossAxisSpacing: 1,
              //             // mainAxisSpacing: 5,
              //             mainAxisExtent: 140,
              //         ),
              //         itemCount: snapshot.data!.docs.length,
              //         itemBuilder: (context, index) {
              //
              //
              //           return InkWell(
              //             onTap: () {
              //               testController.carName= index;
              //               testController.companyName = snapshot.data!.docs[index]['company'].toString();
              //               debugPrint(testController.carName.toString());
              //                  Get.to(()=> TestScreen());
              //             },
              //             splashColor: ConstColour.btnHowerColor,
              //             child: Card(
              //               shape: BeveledRectangleBorder(
              //                 borderRadius: BorderRadius.circular(21)
              //               ),
              //               // color: ConstColour.cardBgColor,
              //               color:StickyColors.colors[_random.nextInt(10)],
              //             child: Column(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Padding(
              //                   padding: EdgeInsets.only(top: deviceHeight * 0.02),
              //                   child: Image.network(snapshot.data!.docs[index]['image'].toString(),width : deviceWidth * 0.2),
              //                 ),
              //                 Card(child: Padding(
              //                   padding: EdgeInsets.only(left: deviceWidth * 0.01,right: deviceWidth * 0.01),
              //                   child: Text(snapshot.data!.docs[index]['company'].toString(),style: TextStyle(fontFamily: ConstFont.popinsMedium,)),
              //                 )),
              //               ],
              //             ),
              //             ),
              //           );
              //
              //         },
              //       );
              //     }
              // ),




              // StreamBuilder<QuerySnapshot>(
              //     stream: cars,
              //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting)
              //         return CircularProgressIndicator();
              //       if(snapshot.hasError)
              //         return Text(("Some Error"));
              //       return ListView.builder(
              //         controller: ScrollController(),
              //         scrollDirection: Axis.vertical,
              //         shrinkWrap: true,
              //         itemCount: snapshot.data!.docs.length,
              //         itemBuilder: (context, index) {
              //
              //
              //           return Padding(
              //             padding: const EdgeInsets.all(5.0),
              //             child: Card(
              //               child: ListTile(
              //                 onTap: () {
              //                 // Get.to(()=> CarDetailScreen());
              //                 // Get.to(()=> DetailScreen());
              //                   testController.carName= index;
              //                   debugPrint(testController.carName.toString());
              //                 Get.to(()=> TestScreen());
              //                 },
              //                 splashColor: Colors.white,
              //                 leading: Image.network(snapshot.data!.docs[index]['image'].toString(),width : 90),
              //                 title: Text(snapshot.data!.docs[index]['company'].toString()),
              //               ),
              //             ),
              //           );
              //         },
              //       );
              //     }
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
