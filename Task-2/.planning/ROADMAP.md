# Roadmap: Random Quote App

**Created:** 2026-03-25
**Core Value:** Users see a fresh, beautifully presented inspirational quote every time they open the app
**Granularity:** Coarse (4 phases)

## Overview

| # | Phase | Goal | Requirements | Success Criteria |
|---|-------|------|--------------|------------------|
| 1 | Project Scaffold | Create Flutter project with Android config and dependencies | SETUP-01, SETUP-02, SETUP-03 | 3 |
| 2 | Data & State Layer | Build data model, static quotes, and Provider state management | DATA-01, DATA-02, STATE-01, STATE-02, STATE-03 | 4 |
| 3 | App Shell & Theme | Configure MaterialApp with dark theme, system chrome, and fonts | SHELL-01 to SHELL-06 | 4 |
| 4 | UI Components & Home Screen | Build QuoteCard, NewQuoteButton widgets, and assemble HomeScreen | QUOTE-01 to QUOTE-07, HOME-01 to HOME-07 | 5 |

**Total phases:** 4
**Total requirements:** 28
**Coverage:** 100% ✓

---

## Phase 1: Project Scaffold [✓ 2026-03-25]

**Goal:** Create the Flutter project configured for Android-only, install all dependencies, and set up the folder structure.

**Requirements:** SETUP-01, SETUP-02, SETUP-03

**UI hint:** no

**Success Criteria:**
1. Flutter project runs on Android emulator/device with default screen
2. All three dependencies (provider, google_fonts, animate_do) resolve on `flutter pub get`
3. Folder structure exists: `lib/models/`, `lib/data/`, `lib/providers/`, `lib/screens/`, `lib/widgets/`

---

## Phase 2: Data & State Layer [✓ 2026-03-25]

**Goal:** Create the Quote model, populate 20+ static quotes, and implement QuoteProvider with random quote logic (no consecutive duplicates).

**Requirements:** DATA-01, DATA-02, STATE-01, STATE-02, STATE-03

**UI hint:** no

**Success Criteria:**
1. `Quote` model has `text` and `author` String fields with const constructor
2. `QuotesData.quotes` list contains at least 20 unique `Quote` objects
3. `QuoteProvider.loadRandomQuote()` always returns a different quote than the current one
4. Provider initializes with a random quote on creation

---

## Phase 3: App Shell & Theme

**Goal:** Configure the root MaterialApp with Material 3 dark theme, custom color scheme, Google Fonts, portrait lock, and transparent status bar.

**Requirements:** SHELL-01, SHELL-02, SHELL-03, SHELL-04, SHELL-05, SHELL-06

**UI hint:** yes

**Success Criteria:**
1. App launches with dark background (#0D0D0D) and golden accent (#F5C518) color scheme
2. Text renders in Inter font family (Google Fonts)
3. App locked to portrait orientation — rotation has no effect
4. Status bar is transparent with light-colored icons

---

## Phase 4: UI Components & Home Screen

**Goal:** Build the polished QuoteCard and NewQuoteButton widgets, then assemble the HomeScreen with top bar, centered card, and bottom button section.

**Requirements:** QUOTE-01 through QUOTE-07, HOME-01 through HOME-07

**UI hint:** yes

**Success Criteria:**
1. Quote card shows decorative `"` mark, italic quote text in Playfair Display, divider, and author name
2. Tapping "New Quote" button shows a different quote with a FadeInUp animation
3. Home screen layout: app title top-left, quote icon top-right, card centered, button at bottom
4. Card has dark surface, rounded corners, subtle border, and shadow
5. All UI elements use the correct colors from the design system

---

## Dependencies

```
Phase 1 (Project Scaffold) → Phase 2 (Data & State) → Phase 3 (App Shell) → Phase 4 (UI Components)
```

All phases are sequential — each builds on the previous.

---
*Roadmap created: 2026-03-25*
*Last updated: 2026-03-25 after initial creation*
