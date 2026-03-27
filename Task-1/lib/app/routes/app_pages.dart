// lib/app/routes/app_pages.dart

import 'package:get/get.dart';
import '../../features/home/home_screen.dart';
import '../../features/manage/manage_screen.dart';
import '../bindings/home_binding.dart';
import '../bindings/manage_binding.dart';
import 'app_routes.dart';

abstract class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.manage,
      page: () => const ManageScreen(),
      binding: ManageBinding(),
    ),
  ];
}
