// lib/data/services/storage_service.dart

import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_constants.dart';
import '../models/flashcard.dart';

abstract class StorageService {
  List<Flashcard> readAll();
  void writeAll(List<Flashcard> cards);
}

class StorageServiceImpl implements StorageService {
  final GetStorage _box = GetStorage();

  @override
  List<Flashcard> readAll() {
    final List<dynamic>? data = _box.read(AppConstants.storageKey);
    if (data == null) return [];
    
    return data.map((json) => Flashcard.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  @override
  void writeAll(List<Flashcard> cards) {
    final List<Map<String, dynamic>> data = cards.map((card) => card.toJson()).toList();
    _box.write(AppConstants.storageKey, data);
  }
}
