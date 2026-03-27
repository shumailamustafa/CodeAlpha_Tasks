import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/quote_model.dart';
import '../data/quotes_data.dart';

class QuoteProvider with ChangeNotifier {
  Quote? _currentQuote;
  int? _previousIndex;
  final Random _random = Random();

  Quote? get currentQuote => _currentQuote;

  QuoteProvider() {
    loadRandomQuote();
  }

  void loadRandomQuote() {
    if (QuotesData.quotes.isEmpty) return;

    if (QuotesData.quotes.length == 1) {
      _currentQuote = QuotesData.quotes[0];
      _previousIndex = 0;
      notifyListeners();
      return;
    }

    int nextIndex;
    do {
      nextIndex = _random.nextInt(QuotesData.quotes.length);
    } while (nextIndex == _previousIndex);

    _currentQuote = QuotesData.quotes[nextIndex];
    _previousIndex = nextIndex;
    notifyListeners();
  }
}
