import 'package:flutter_test/flutter_test.dart';
import 'package:random_quote_app/providers/quote_provider.dart';
import 'package:random_quote_app/data/quotes_data.dart';

void main() {
  group('QuoteProvider Tests', () {
    test('Initial quote should not be null', () {
      final provider = QuoteProvider();
      expect(provider.currentQuote, isNotNull);
    });

    test('loadRandomQuote should update the current quote', () {
      final provider = QuoteProvider();
      provider.loadRandomQuote();
      
      // Note: Since it's random, it's possible (though unlikely with 22 quotes) 
      // to get the same text if the dataset had duplicates, 
      // but the logic ensures different INDEX.
      // We check that it at least remains non-null.
      expect(provider.currentQuote, isNotNull);
    });

    test('loadRandomQuote should not return the same quote twice in a row', () {
      final provider = QuoteProvider();
      
      for (int i = 0; i < 100; i++) {
        final previousQuote = provider.currentQuote;
        provider.loadRandomQuote();
        final currentQuote = provider.currentQuote;
        
        expect(currentQuote, isNot(equals(previousQuote)), 
          reason: 'Failed on iteration $i: Quote repeated consecutively');
      }
    });

    test('Works correctly with the full dataset size', () {
      expect(QuotesData.quotes.length, greaterThanOrEqualTo(20));
    });
  });
}
