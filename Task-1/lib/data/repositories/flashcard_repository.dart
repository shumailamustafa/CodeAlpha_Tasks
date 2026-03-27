// lib/data/repositories/flashcard_repository.dart

import 'package:uuid/uuid.dart';
import '../models/flashcard.dart';
import '../services/storage_service.dart';

abstract class FlashcardRepository {
  List<Flashcard> getAllCards();
  void addCard(String question, String answer);
  void updateCard(String id, String question, String answer);
  void deleteCard(String id);
  void addMultipleCards(List<Map<String, String>> cardData);
}

class FlashcardRepositoryImpl implements FlashcardRepository {
  final StorageService _storageService;
  final _uuid = const Uuid();

  FlashcardRepositoryImpl(this._storageService);

  @override
  List<Flashcard> getAllCards() {
    final cards = _storageService.readAll();
    if (cards.isEmpty) {
      // Seed with sample data for first-time use
      final sampleCards = [
        Flashcard(
          id: _uuid.v4(),
          question: 'What is the capital of France?',
          answer: 'Paris',
          createdAt: DateTime.now(),
        ),
        Flashcard(
          id: _uuid.v4(),
          question: 'What is 15 + 27?',
          answer: '42',
          createdAt: DateTime.now(),
        ),
        Flashcard(
          id: _uuid.v4(),
          question: 'How do you flip a card in FlashMind?',
          answer: 'Just tap on the card face!',
          createdAt: DateTime.now(),
        ),
      ];
      _storageService.writeAll(sampleCards);
      return sampleCards;
    }
    return cards;
  }

  @override
  void addCard(String question, String answer) {
    final cards = _storageService.readAll();
    final newCard = Flashcard(
      id: _uuid.v4(),
      question: question,
      answer: answer,
      createdAt: DateTime.now(),
    );
    cards.add(newCard);
    _storageService.writeAll(cards);
  }

  @override
  void updateCard(String id, String question, String answer) {
    final cards = _storageService.readAll();
    final index = cards.indexWhere((card) => card.id == id);
    if (index != -1) {
      cards[index] = cards[index].copyWith(
        question: question,
        answer: answer,
      );
      _storageService.writeAll(cards);
    }
  }

  @override
  void deleteCard(String id) {
    final cards = _storageService.readAll();
    cards.removeWhere((card) => card.id == id);
    _storageService.writeAll(cards);
  }

  @override
  void addMultipleCards(List<Map<String, String>> cardData) {
    final cards = _storageService.readAll();
    for (var data in cardData) {
      if (data.containsKey('question') && data.containsKey('answer')) {
        cards.add(Flashcard(
          id: _uuid.v4(),
          question: data['question']!,
          answer: data['answer']!,
          createdAt: DateTime.now(),
        ));
      }
    }
    _storageService.writeAll(cards);
  }
}
