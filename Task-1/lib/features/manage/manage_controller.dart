// lib/features/manage/manage_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import '../../data/models/flashcard.dart';
import '../../data/repositories/flashcard_repository.dart';
import '../home/home_controller.dart';

class ManageController extends GetxController {
  final FlashcardRepository repository;
  ManageController(this.repository);

  final RxList<Flashcard> allCards = <Flashcard>[].obs;
  final RxList<Flashcard> filteredCards = <Flashcard>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCards();
    
    // Set up real-time search filtering
    ever(searchQuery, (_) => _applyFilter());
  }

  void loadCards() {
    isLoading.value = true;
    try {
      final cards = repository.getAllCards();
      allCards.assignAll(cards);
      _applyFilter();
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilter() {
    if (searchQuery.isEmpty) {
      filteredCards.assignAll(allCards);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredCards.assignAll(
        allCards.where((card) =>
            card.question.toLowerCase().contains(query) ||
            card.answer.toLowerCase().contains(query))
            .toList(),
      );
    }
  }

  void addCard(String question, String answer) {
    repository.addCard(question, answer);
    loadCards();
    _syncHome();
  }

  void updateCard(String id, String question, String answer) {
    repository.updateCard(id, question, answer);
    loadCards();
    _syncHome();
  }

  void deleteCard(String id) {
    repository.deleteCard(id);
    loadCards();
    _syncHome();
  }

  void _syncHome() {
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadCards();
    }
  }

  Future<void> importFromCsv() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final input = file.openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(Csv().decoder)
          .toList();

      final List<Map<String, String>> newCards = [];
      for (var row in fields) {
        if (row.length >= 2) {
          newCards.add({
            'question': row[0].toString().trim(),
            'answer': row[1].toString().trim(),
          });
        }
      }

      if (newCards.isNotEmpty) {
        repository.addMultipleCards(newCards);
        loadCards();
        _syncHome();
        Get.snackbar(
          'Success',
          'Imported ${newCards.length} cards successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to import CSV: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(51),
        colorText: Colors.red,
      );
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query; // Added this line to actually update the query
  }
}
