# Phase 4: UI Components & Home Screen - Context

**Gathered:** 2026-03-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Final visual implementation: building the `QuoteCard` widget, the `NewQuoteButton`, and assembling the animated `HomeScreen` layout.

</domain>

<decisions>
## Implementation Decisions

### Quote Card (The Centerpiece)
- **D-01:** **Dynamic Height:** The card will expand to fit the quote text. It will be centered vertically in the home screen using `Spacer` or `Center`.
- **D-02:** **Aesthetics:** 20px rounded corners, #1A1A1A surface background, #F5C518 golden border (0.5px), and a subtle golden glow shadow (`BoxShadow`).
- **D-03:** **Typography:** Quote text in `Playfair Display` (italic, Serif), Author name in `Inter` (Sans-serif) below a subtle silver/grey horizontal divider.

### Animations
- **D-04:** **Multi-trigger Animation:** Use `FadeInUp` from `animate_do` on the entire `QuoteCard`.
- **D-05:** **Refresh Logic:** Use a `ValueKey(currentQuote.text)` on the `FadeInUp` widget to ensure the animation re-triggers every time the quote updates.

### Home Screen Layout
- **D-06:** **Header:** A top-level `Row` with "Daily Quotes" in Playfair Display (left) and a decorative `Container` holding a `FormatQuote` icon (right).
- **D-07:** **Button:** A golden (#F5C518) pill-shaped button at the bottom with a subtle glow and "New Quote" label.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Requirements
- [REQUIREMENTS.md](file:///c:/Users/Moazzam%20Samoo/Desktop/Task-2/.planning/REQUIREMENTS.md) — QUOTE-01 to QUOTE-07, HOME-01 to HOME-07

### Code Context
- [lib/providers/quote_provider.dart](file:///c:/Users/Moazzam%20Samoo/Desktop/Task-2/random_quote_app/lib/providers/quote_provider.dart) — State source

</canonical_refs>
