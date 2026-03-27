// lib/app/bindings/home_binding.dart

import 'package:get/get.dart';
import '../../data/repositories/flashcard_repository.dart';
import '../../data/services/storage_service.dart';
import '../../features/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageService>(() => StorageServiceImpl());
    Get.lazyPut<FlashcardRepository>(() => FlashcardRepositoryImpl(Get.find()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
