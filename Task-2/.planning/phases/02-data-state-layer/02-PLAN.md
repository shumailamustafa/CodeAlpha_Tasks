---
phase: 02-data-state-layer
requirements_addressed: [DATA-01, DATA-02, STATE-01, STATE-02, STATE-03]
status: pending
---

# Phase 2: Data & State Layer - Plan

Implement the core data model, populate static quote data, and set up state management using Provider.

## Wave 1: Data structures
### Task 1: Create Quote Model
<read_first>
- lib/models/
</read_first>
<action>
Create `lib/models/quote_model.dart`. Define a class `Quote` with:
- `final String text;`
- `final String author;`
- A `const` constructor.
</action>
<acceptance_criteria>
- `lib/models/quote_model.dart` exists.
- `Quote` class has `text` and `author` fields and a `const` constructor.
</acceptance_criteria>

### Task 2: Create Static Data
<read_first>
- lib/models/quote_model.dart
- lib/data/
</read_first>
<action>
Create `lib/data/quotes_data.dart`. Define a class `QuotesData` with a static list `static const List<Quote> quotes = [...]` containing at least 20 unique quotes.
</action>
<acceptance_criteria>
- `lib/data/quotes_data.dart` exists.
- It contains at least 20 `Quote` objects.
</acceptance_criteria>

## Wave 2: State Management
### Task 3: Implement QuoteProvider
<read_first>
- lib/models/quote_model.dart
- lib/data/quotes_data.dart
- lib/providers/
</read_first>
<action>
Create `lib/providers/quote_provider.dart`. Define `QuoteProvider` extending `ChangeNotifier`:
- Store `Quote? _currentQuote`.
- Store `int? _previousIndex`.
- Include a method `void loadRandomQuote()` that:
  - Picks a random index from `QuotesData.quotes` that is not equal to `_previousIndex`.
  - Updates `_currentQuote` and `_previousIndex`.
  - Calls `notifyListeners()`.
- The constructor should call `loadRandomQuote()` to set an initial quote.
</action>
<acceptance_criteria>
- `lib/providers/quote_provider.dart` exists.
- `loadRandomQuote()` prevents consecutive duplicates.
- Initial quote is set on creation.
</acceptance_criteria>

## Wave 3: App Wiring
### Task 4: Root Provider Setup
<read_first>
- lib/main.dart
- lib/providers/quote_provider.dart
</read_first>
<action>
Modify `lib/main.dart` to wrap the `MaterialApp` (or the entire `MyApp` if preferred) with a `ChangeNotifierProvider<QuoteProvider>`.
</action>
<acceptance_criteria>
- `lib/main.dart` uses `ChangeNotifierProvider` from `provider` package.
- `QuoteProvider` is provided at the root of the app.
</acceptance_criteria>

## Verification Plans
### Automated Tests
- Run `flutter analyze` to ensure code correctness.
- (Optional) Create a simple unit test for `QuoteProvider` to verify no-consecutive-duplicate logic.

### Manual Verification
- N/A - To be verified in Phase 4 during UI assembly.
