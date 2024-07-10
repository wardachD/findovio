import 'package:get/get.dart';

import '../controllers/bottom_app_bar_index_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BottomAppBarIndexController>(
      BottomAppBarIndexController(),
      permanent: true,
    );
  }
}
