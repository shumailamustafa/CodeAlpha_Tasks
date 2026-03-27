// lib/app/bindings/manage_binding.dart

import 'package:get/get.dart';
import '../../features/manage/manage_controller.dart';

class ManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageController>(() => ManageController(Get.find()));
  }
}
