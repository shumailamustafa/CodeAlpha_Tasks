# Phase 4: UI Components & Home Screen - Plan

**Phase Goal:** Implement the final polished UI, animations, and reactive home screen.

## 📋 Requirements
- [ ] **QUOTE-01/02/03**: Quote card with Playfair font, golden quote mark, and author divider
- [ ] **QUOTE-04/05**: Card aesthetics (Surface color, 20px corners, border, shadow)
- [ ] **QUOTE-06/07**: FadeInUp animation with ValueKey refresh logic
- [ ] **HOME-01/02**: App header with logo and decorative icon
- [ ] **HOME-04/05/06**: Golden "New Quote" pill button with helper text
- [ ] **HOME-07**: Reactive state binding with `Consumer<QuoteProvider>`

## 🛠️ Implementation Steps

### 1. Quote Card Widget
- [ ] Create `lib/widgets/quote_card.dart`.
- [ ] Build a stateless widget that takes a `Quote` object.
- [ ] Implement the decorative large opening quote mark.
- [ ] Apply `Playfair Display` italic to the quote text.
- [ ] Add the divider and author name.
- [ ] Apply the #1A1A1A surface styling and rounded/glow effects.

### 2. New Quote Button Widget
- [ ] Create `lib/widgets/new_quote_button.dart`.
- [ ] Build a pill-shaped button with golden background and black text/icon.
- [ ] Add the subtle golden glow shadow.

### 3. Home Screen Assembly
- [ ] Update `HomeScreen` in `lib/main.dart` (or move to `lib/screens/home_screen.dart`).
- [ ] Use `Scaffold` with `SafeArea`.
- [ ] Implement the top header row.
- [ ] Wrap the center section in `Consumer<QuoteProvider>`.
- [ ] Place the `QuoteCard` inside `FadeInUp` with `ValueKey`.
- [ ] Place the `NewQuoteButton` at the bottom and link its `onPressed` to `provider.loadRandomQuote()`.

## 🧪 Verification Plan
- [ ] **Functional:** Tap "New Quote" and verify the quote updates on screen.
- [ ] **Visual:** Verify fonts (Serif for quotes, Sans-serif for author).
- [ ] **Visual:** Verify colors match #0D0D0D and #F5C518.
- [ ] **Animation:** Confirm the card fades and slides up on refresh.
- [ ] **State:** Verify no consecutive duplicates occur (logical check from Phase 2).
