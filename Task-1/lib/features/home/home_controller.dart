import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/flashcard.dart';
import '../../data/repositories/flashcard_repository.dart';

class HomeController extends GetxController {
  final FlashcardRepository repository;
  HomeController(this.repository);

  final RxList<Flashcard> cards = <Flashcard>[].obs;
  final RxInt currentIndex = 0.obs;
  final RxBool isFlipped = false.obs;
  final RxBool isLoading = true.obs;

  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    loadCards();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> loadCards() async {
    isLoading.value = true;
    try {
      final loadedCards = repository.getAllCards();
      cards.assignAll(loadedCards);
      currentIndex.value = 0;
      isFlipped.value = false;
      // Reset page controller if needed
      if (pageController.hasClients) {
        pageController.jumpToPage(0);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    isFlipped.value = false;
  }

  void nextCard() {
    if (currentIndex.value < cards.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousCard() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void toggleFlip() {
    isFlipped.toggle();
  }

  Flashcard? get currentCard =>
      cards.isNotEmpty ? cards[currentIndex.value] : null;
}
