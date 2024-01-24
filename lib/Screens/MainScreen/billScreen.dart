import 'dart:io';
import 'package:car_selling/ConstFile/constColors.dart';
import 'package:car_selling/Controllers/homeController.dart';
import 'package:car_selling/widgets/round_button.dart';
import 'package:file_selector/file_selector.dart' hide XFile; // hides to test if share_plus exports XFile
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart' hide XFile; // hides to test if share_plus exports XFile
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import '../../ConstFile/constFonts.dart';
import '../../Controllers/cardetail_controller.dart';
import 'BottomBarScreen.dart';

class BillScreen extends StatefulWidget {


  String? name;
  String? email;
  String? mobile;
  String? address;
  String? date;
  String? modal;
  String? price;

    BillScreen(this.name,this.email,this.address,this.mobile,this.modal,this.price,this.date);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  HomeController homeController = Get.put(HomeController());
  CarDetailController carDetailController = Get.put(CarDetailController());


  final controller = ScreenshotController();
  User? user = FirebaseAuth.instance.currentUser;
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

  }
  @override
  Widget build(BuildContext context) {

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return   WillPopScope(
      onWillPop: () async {
        setState(() {
          Get.to(()=> const BottomBarScreen(),arguments: homeController.currentIndex = 0);

        });
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundButton(title: "Go to HomePage", onTap: () {
            Get.to(()=> const BottomBarScreen(),arguments: homeController.currentIndex = 0);
            disposeController();
          },),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ConstColour.primaryColor,
          centerTitle: true,
          title: const Text("Bill",
              style: TextStyle(fontFamily: ConstFont.popinsMedium)),
        ),
        floatingActionButton:     ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              elevation: 5.0,
            ),
            onPressed: () async {
              final image =    await controller.captureFromWidget(buidImage());

              saveAndShare(image);

              // final image =    await controller.capture();
              if(image == null)
                return null;

              await saveImage(image);

            }, child: const Row(
          mainAxisSize: MainAxisSize.min,
              children: [
                Text("Share a screenshot  "),
                Icon(Icons.share,color: Colors.white,)
              ],
            )),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32,),
              Screenshot(
                  controller: controller,
                  child: buidImage()),
              const SizedBox(height: 32,),
              // ElevatedButton(onPressed: () async {
              // final image =    await controller.capture();
              // if(image == null)
              //   return null;
              //
              // await saveImage(image);
              //
              // }, child: Text("Capture Screen")),
              // SizedBox(height: 10),
              // ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.black,
              //       elevation: 5.0,
              //     ),
              //     onPressed: () async {
              //   final image =    await controller.captureFromWidget(buidImage());
              //
              //   saveAndShare(image);
              //
              //   // final image =    await controller.capture();
              //   if(image == null)
              //     return null;
              //
              //   await saveImage(image);
              //
              // }, child: Text("Share a screenshot"))
            ],
          ),
        ),

      ),
    );
  }

  Future<String> saveAndShare(Uint8List bytes)async{
    final directory  = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);

    final text = "Congratulations for new car";
    // await Share.shareXFiles(image.path,text: text);
    await Share.shareFiles([image.path],text: text);
    return "ok";
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();

      final time = DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');
    final name = "screenshot_$time";

      final result  = await ImageGallerySaver.saveImage(bytes,name: name);
      return result['filePath'];
  }



  Widget buidImage() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11)
      ),
      elevation: 20.0,
      color: Colors.white,
      child: Column(
         mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
             decoration: const BoxDecoration(
               borderRadius: BorderRadius.only(topRight: Radius.circular(11),topLeft: Radius.circular(11))
                   ,
               color: ConstColour.primaryColor,

             ),
              child: const Center(child: Column(
                children: [
                  SizedBox(height: 10,),
                  Text("Bill Receipt",style: TextStyle(fontSize: 30,fontFamily: ConstFont.ruwuduMedium,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                ],
              ))),
         Padding(
           padding: const EdgeInsets.only(left: 15,top: 20),
           child: Row(
                children: [const Text("Name : ",style:TextStyle(fontFamily: ConstFont.popinsMedium,fontSize: 18) ),
                  Text(widget.name.toString(),style: const TextStyle(fontSize: 14)),
                ],
              ),
         ),

          Padding(
            padding: const EdgeInsets.only(left: 15,top: 10),
            child: Row(
                children: [const Text("Email : ",style:TextStyle(fontFamily: ConstFont.popinsMedium,fontSize: 18) ),
                  Text(widget.email.toString(),style: const TextStyle(fontSize: 14)),
                ],
              ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15,top: 10),
            child: Row(
               children: [
                 const Text("Mobile No : ",style:TextStyle(fontFamily: ConstFont.popinsMedium,fontSize: 18) ),
                 Text(widget.mobile.toString(),style: const TextStyle(fontSize: 14)),
               ],
             ),
          ),



          const Padding(
            padding: EdgeInsets.only(left: 15,top: 10),
            child: Row(
                children: [
                  Text("Delivery Address : ",style:TextStyle(fontFamily: ConstFont.popinsMedium,fontSize: 18),maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                ],
              ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(widget.address.toString(),maxLines: 3,
                overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 14)),
          ),

           Padding(
             padding: const EdgeInsets.only(left: 15,top: 10),
             child: Row(
                children: [const Text("Delivery Date : ",style:TextStyle(fontFamily: ConstFont.popinsMedium,fontSize: 18) ),
                  Text(widget.date.toString(),style: const TextStyle(fontSize: 14)),
                ],
              ),
           ),

         Padding(
           padding: const EdgeInsets.only(left: 15,top: 10),
           child: Row(
                children: [const Text("Car Modal : ",style:TextStyle(fontFamily: ConstFont.popinsMedium,fontSize: 18) ),
                  Text(widget.modal.toString(),style: const TextStyle(fontSize: 14)),
                ],

            ),
         ),  Padding(
           padding: const EdgeInsets.only(top: 50,bottom: 10),
           child: ElevatedButton(
             // clipBehavior: Clip.antiAliasWithSaveLayer,
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.black,
              elevation: 5.0,
             ),
              onPressed: () {

              },
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const Text("Total Price : ",style:TextStyle(fontFamily: ConstFont.popinsMedium,fontSize: 23,fontWeight: FontWeight.w600) ),
                      Text("₹ "+widget.price.toString(),style: const TextStyle(fontSize: 18)),
                    ],

                ),
             ),
           ),
         ),

          // AspectRatio(aspectRatio: 1,
          //   child: Image.network("https://firebasestorage.googleapis.com/v0/b/carapp-da674.appspot.com/o/car_images%2Fbmw%20740i.png?alt=media&token=7bea0bbf-3829-4bea-9da3-fa20a9c89503",fit: BoxFit.cover,),
          // ),
          // Center(
          //   child:Text("Summer ",style: TextStyle(fontSize: 32)),
          // )
        ],
      ),
    ),
  );
}
