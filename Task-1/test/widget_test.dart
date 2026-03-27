// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flashmind/app/app.dart';
import 'package:flashmind/data/models/flashcard.dart';
import 'package:flashmind/data/repositories/flashcard_repository.dart';

class MockFlashcardRepository extends FlashcardRepository {
  @override
  List<Flashcard> getAllCards() => [];
  @override
  void addCard(String question, String answer) {}
  @override
  void updateCard(String id, String question, String answer) {}
  @override
  void deleteCard(String id) {}
  @override
  void addMultipleCards(List<Map<String, String>> cardData) {}
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Inject mock repository permanently before any app building starts
    Get.put<FlashcardRepository>(MockFlashcardRepository(), permanent: true);
  });

  testWidgets('App navigation and empty state test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlashMindApp());
    await tester.pumpAndSettle();

    // 1. Verify Home Screen loads and shows empty state message
    expect(find.text('No flashcards yet!'), findsOneWidget);
    expect(find.text('Tap the folder icon to add some.'), findsOneWidget);

    // 2. Tap on the manage icon (folder)
    final manageIcon = find.byIcon(Icons.folder_open);
    expect(manageIcon, findsOneWidget);
    await tester.tap(manageIcon);
    await tester.pumpAndSettle();

    // 3. Verify Manage Screen is visible
    expect(find.text('Manage Deck'), findsOneWidget);
    expect(find.text('Your deck is empty.\nTap + to add cards!'), findsOneWidget);
  });
}
