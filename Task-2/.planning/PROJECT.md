# Random Quote App

## What This Is

A clean, minimal Random Quote App built in Flutter for Android. The app displays a new inspirational quote every time it launches or the user taps the "New Quote" button. Features a polished dark UI with elegant typography, smooth animations, and Provider-based state management.

## Core Value

Users see a fresh, beautifully presented inspirational quote every time they open the app or tap "New Quote" — never the same quote twice in a row.

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

- [x] SETUP-01 (Android-only project) — Phase 1
- [x] SETUP-02 (Core dependencies) — Phase 1
- [x] SETUP-03 (Folder architecture) — Phase 1

### Active

<!-- Current scope. Building toward these. -->

- [ ] Display a random quote on app launch
- [ ] "New Quote" button shows a different quote each tap
- [ ] No repeated quote back-to-back
- [ ] Quote text and author displayed clearly
- [ ] Clean, minimal dark UI with golden accent
- [ ] Smooth fade-in animation on each new quote
- [ ] Portrait-only orientation locked
- [ ] Transparent status bar
- [ ] State managed via Provider


### Out of Scope

<!-- Explicit boundaries. Includes reasoning to prevent re-adding. -->

- iOS support — Android-only per project scope
- Web/Desktop support — Mobile-only app
- API-based quotes — Using local static data for simplicity and offline access
- User accounts/authentication — No user-specific features
- Favorites/bookmarks — Keep minimal for v1
- Share functionality — Not in v1 scope
- Categories/filtering — All quotes from a single mixed list
- Dark/Light theme toggle — Dark theme only

## Context

- **Tech Stack:** Flutter (Dart), Material 3, Provider for state management
- **Platform:** Android only
- **Dependencies:** `provider ^6.1.2`, `google_fonts ^6.2.1`, `animate_do ^3.3.4`
- **Design System:** Dark theme (#0D0D0D bg), golden accent (#F5C518), Playfair Display for quotes, Inter for UI
- **Data Source:** 20 hardcoded quotes covering motivation, wisdom, life, and creativity
- **Reference:** Implementation plan provided in `random_quote_app_plan.md`

## Constraints

- **Tech Stack**: Flutter with Provider — Per project specification
- **Platform**: Android only — No iOS/Web/Desktop builds
- **Dependencies**: Only `provider`, `google_fonts`, `animate_do` — No extra packages
- **Data**: 20 static quotes — No network/API calls

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Provider for state management | Lightweight, sufficient for single-screen app | — Pending |
| Static quote data (no API) | Offline-first, simpler architecture, faster performance | — Pending |
| Dark theme only | Elegant, modern look aligned with premium design | — Pending |
| Playfair Display serif font for quotes | Creates contrast between quote content and UI, feels literary | — Pending |
| FadeInUp animation on quote change | Subtle but noticeable transition, provides visual feedback | — Pending |
| Android-only build | Reduces complexity, faster iteration per user requirement | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

## Current State
- **Infrastructure:** Flutter project initialized in `random_quote_app/`.
- **Targeting:** Android-only (`ios/` deleted).
- **Dependencies:** `provider`, `google_fonts`, `animate_do` configured.
- **Structure:** `lib/` subdirectories created: `models/`, `data/`, `providers/`, `screens/`, `widgets/`.

---
*Last updated: 2026-03-25 after Phase 1 completion*
