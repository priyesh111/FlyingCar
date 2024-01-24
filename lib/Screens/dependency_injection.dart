import 'package:get/get.dart';

import '../Controllers/network_controller.dart';

class DependencyInjection {

  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}