// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local storage
  await GetStorage.init();
  
  runApp(const FlashMindApp());
}
