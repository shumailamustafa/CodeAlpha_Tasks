# 📚 FlashMind — Flutter Flashcard Quiz App

> **Product Requirements Document (PRD) + Master AI Prompt**
> Version 1.0 · March 2026
> Architecture: MVVM · State Management: GetX · Platform: Flutter (iOS & Android)

---

## 1. Product Overview

### 1.1 Executive Summary

FlashMind is a cross-platform mobile flashcard quiz application built with Flutter. It enables students, professionals, and lifelong learners to create, manage, and study customized flashcard decks on both iOS and Android devices. The app is designed around simplicity, speed, and a clean UI — allowing users to focus entirely on learning.

### 1.2 Product Goals

- Provide a distraction-free, intuitive study experience on mobile
- Enable full CRUD (Create, Read, Update, Delete) operations on flashcards
- Persist flashcard data locally without requiring user accounts or internet
- Deliver smooth, native-feeling card flip animations
- Follow production-grade Flutter architecture (MVVM + GetX + Clean Code)

### 1.3 Target Audience

| Persona           | Use Case                        | Frequency  |
|-------------------|---------------------------------|------------|
| Students          | Exam prep (MCQs, vocab)         | Daily      |
| Language Learners | Vocabulary & phrases            | Daily      |
| Professionals     | Technical terms, certifications | Weekly     |
| Self-Learners     | General knowledge               | Occasional |

### 1.4 Tech Stack

| Layer             | Technology                   | Purpose                          |
|-------------------|------------------------------|----------------------------------|
| Framework         | Flutter 3.x (Dart)           | Cross-platform mobile UI         |
| State Management  | GetX                         | Reactive state, navigation, DI   |
| Architecture      | MVVM + Clean Code            | Separation of concerns           |
| Local Storage     | GetStorage / Hive            | Persist flashcard data           |
| Animations        | Flutter AnimationController  | Card flip 3D effect              |
| UI Theme          | Material Design 3            | Modern, clean styling            |

---

## 2. Feature Requirements

### 2.1 Core Features (MVP)

#### F-01 — Flashcard Quiz Screen
- Display one flashcard at a time (Question side facing up)
- Animated 3D flip on "Show Answer" button tap (Y-axis rotation)
- Counter showing current card position: e.g., "Card 3 of 12"
- "Previous" button — navigates to the prior card (disabled on first card)
- "Next" button — navigates to the next card (disabled on last card)
- Empty state screen when no flashcards exist yet

#### F-02 — Add Flashcard
- Floating Action Button (FAB) on Home screen opens Add Card modal/sheet
- Input field: Question (multi-line, max 300 chars)
- Input field: Answer (multi-line, max 500 chars)
- Both fields are required — validation shown on submit
- "Save" button adds card to the deck immediately (reactive UI)
- "Cancel" dismisses the sheet without saving

#### F-03 — Edit Flashcard
- Long-press or "Edit" icon on a card opens Edit modal pre-filled with current data
- User can update question and/or answer text
- "Update" button saves changes and refreshes UI
- Validation mirrors Add flow

#### F-04 — Delete Flashcard
- Swipe-to-delete gesture OR Delete icon from card options
- Confirmation dialog: "Delete this flashcard? This cannot be undone."
- Deleted card removed from list and storage immediately
- If last card deleted → show empty state

#### F-05 — Deck Management Screen
- Scrollable list of all flashcards (Question preview + card number)
- Search bar to filter cards by keyword (question or answer)
- FAB to add new cards
- Each list item has Edit (pencil) and Delete (trash) icon buttons

### 2.2 Nice-to-Have Features (V2)

- Shuffle deck mode (randomize card order)
- Progress tracker (cards marked as "Known" vs "Still Learning")
- Multiple decks / categories
- Dark mode support
- Export/Import deck as JSON

---

## 3. Architecture & Project Structure

### 3.1 MVVM + GetX Architecture

The app follows the Model-View-ViewModel (MVVM) pattern enforced with GetX bindings. Each screen has its own Controller that holds business logic and state. Views are purely declarative — they observe reactive variables from Controllers and never contain logic.

| Layer      | Responsibility                         | Files                        |
|------------|----------------------------------------|------------------------------|
| Model      | Data structures, JSON serialization    | `flashcard.dart`             |
| View       | UI widgets only, no logic              | `*_screen.dart`, `*_widget.dart` |
| ViewModel  | State, business logic, storage calls   | `*_controller.dart`          |
| Repository | Data access abstraction                | `flashcard_repository.dart`  |
| Service    | Storage implementation (GetStorage)    | `storage_service.dart`       |

### 3.2 Full Folder Structure

Every file and folder is commented explaining its purpose:

```
lib/
├── main.dart                        # App entry point; initializes GetStorage & GetX
├── app/
│   ├── app.dart                     # MaterialApp wrapped with GetMaterialApp
│   ├── routes/
│   │   ├── app_pages.dart           # All GetX route definitions (GetPage list)
│   │   └── app_routes.dart          # Route name constants (e.g., Routes.HOME)
│   ├── bindings/
│   │   ├── home_binding.dart        # Injects HomeController & FlashcardRepository
│   │   └── manage_binding.dart      # Injects ManageController
│   └── theme/
│       └── app_theme.dart           # ThemeData: colors, fonts, button styles
├── data/
│   ├── models/
│   │   └── flashcard.dart           # Flashcard model: id, question, answer, createdAt
│   ├── repositories/
│   │   └── flashcard_repository.dart  # Abstract + concrete repo; CRUD methods
│   └── services/
│       └── storage_service.dart     # GetStorage wrapper; read/write JSON list
├── features/
│   ├── home/                        # Quiz / study screen
│   │   ├── home_screen.dart         # View: card flip UI, nav buttons
│   │   ├── home_controller.dart     # ViewModel: currentIndex, showAnswer, navigation
│   │   └── widgets/
│   │       ├── flip_card.dart       # Animated 3D flip card widget
│   │       └── nav_buttons.dart     # Previous / Next button row widget
│   └── manage/                      # Deck management screen
│       ├── manage_screen.dart       # View: list, search, FAB
│       ├── manage_controller.dart   # ViewModel: add/edit/delete/search logic
│       └── widgets/
│           ├── card_list_item.dart  # Single card row with Edit/Delete icons
│           └── card_form_sheet.dart # Bottom sheet form for Add/Edit
└── core/
    ├── constants/
    │   └── app_constants.dart       # Storage keys, default values, limits
    └── utils/
        └── validators.dart          # Form validation helpers (required, maxLen)
```

---

## 4. Data Model

### 4.1 Flashcard Model

Each flashcard is a plain Dart object serialized to JSON for GetStorage persistence.

```dart
// lib/data/models/flashcard.dart
class Flashcard {
  final String id;           // UUID v4 — unique identifier
  final String question;     // Front of card (max 300 chars)
  final String answer;       // Back of card (max 500 chars)
  final DateTime createdAt;  // Timestamp for ordering
}
```

### 4.2 Storage Schema

Data is stored under a single GetStorage key as a JSON array:

```json
{
  "key": "flashcards",
  "value": [
    {
      "id": "a1b2c3d4-...",
      "question": "What is the capital of France?",
      "answer": "Paris",
      "createdAt": "2026-03-20T10:30:00.000Z"
    }
  ]
}
```

---

## 5. UI / UX Specifications

### 5.1 Color Palette

| Token        | Hex Value | Usage                       |
|--------------|-----------|-----------------------------|
| Primary      | `#1565C0` | Buttons, headings, FAB      |
| Accent       | `#42A5F5` | Card borders, active states |
| Background   | `#F5F7FA` | Screen background           |
| Card Surface | `#FFFFFF` | Flashcard face              |
| Error        | `#D32F2F` | Validation messages         |

### 5.2 Screen Specifications

**Screen 1 — Home / Quiz Screen (Default Route)**
- AppBar: "FlashMind 📚" title + Manage Deck icon button (top right)
- Center: FlipCard widget (rounded, shadowed card)
- Card Front: Question text centered, label "QUESTION" at top
- Card Back: Answer text centered, label "ANSWER" at top, distinct bg color (`#E3F2FD`)
- "Show Answer" elevated button below card — triggers flip animation
- Bottom row: `[← Previous]` · `Card X of Y` · `[Next →]`
- Previous/Next styled as OutlinedButtons, disabled state grayed out

**Screen 2 — Manage Deck Screen**
- AppBar: "Manage Deck" title + Back arrow
- Search TextField at top (filters list reactively as user types)
- ListView of CardListItem widgets with question preview
- Each item has trailing Edit (pencil) and Delete (trash) IconButtons
- FAB (bottom right): Opens CardFormSheet for adding new card
- Empty state: Illustration + "No flashcards yet. Tap + to add one."

**Widget — CardFormSheet (Bottom Sheet)**
- Title: "Add Flashcard" or "Edit Flashcard"
- Question TextField (multiline, counter showing X/300)
- Answer TextField (multiline, counter showing X/500)
- Row of two buttons: `[Cancel]` `[Save / Update]`

---

## 6. GetX Implementation Guide

### 6.1 Reactive State

All UI-affecting state variables must be declared as GetX Rx observables. Views use `Obx()` to auto-rebuild when values change.

```dart
// home_controller.dart
class HomeController extends GetxController {
  final FlashcardRepository _repo; // Injected via constructor

  RxList<Flashcard> cards = <Flashcard>[].obs;  // All cards — rebuilds quiz UI
  RxInt currentIndex = 0.obs;                   // Active card index — rebuilds counter & buttons
  RxBool isFlipped = false.obs;                 // Card face state — rebuilds flip widget

  // Computed getters
  bool get hasPrevious => currentIndex.value > 0;
  bool get hasNext => currentIndex.value < cards.length - 1;
  Flashcard? get currentCard =>
      cards.isEmpty ? null : cards[currentIndex.value];
}
```

### 6.2 Dependency Injection via Bindings

Each screen has a Binding class that registers its dependencies with GetX. This keeps the DI layer explicit and testable.

```dart
// home_binding.dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageService>(() => StorageServiceImpl());
    Get.lazyPut<FlashcardRepository>(
        () => FlashcardRepositoryImpl(Get.find()));
    Get.lazyPut<HomeController>(
        () => HomeController(Get.find()));
  }
}
```

### 6.3 Navigation

All navigation uses GetX named routes. No BuildContext needed.

```dart
// app_routes.dart
abstract class Routes {
  static const HOME   = '/';
  static const MANAGE = '/manage';
}

// Navigate from anywhere:
Get.toNamed(Routes.MANAGE);
Get.back();
```

---

## 7. Code Comment Standards

Every file, class, method, and non-trivial variable must be commented. Standards:

### 7.1 File Header (every `.dart` file)
```dart
/// [flashcard.dart]
/// Data model representing a single flashcard entity.
/// Contains: id, question, answer, createdAt timestamp.
/// Includes fromJson/toJson for GetStorage persistence.
```

### 7.2 Class Comments
```dart
/// Controller for the Home (Quiz) screen.
/// Manages: current card index, flip state, deck navigation.
/// Depends on: FlashcardRepository for CRUD operations.
/// Pattern: MVVM ViewModel — no UI code here.
```

### 7.3 Method Comments
```dart
/// Advances to the next flashcard in the deck.
/// Resets the flip state so the question face shows.
/// Does nothing if already on the last card.
void nextCard() { ... }
```

### 7.4 Inline Comments
```dart
// Reset flip so next card always shows question side first
isFlipped.value = false;

// Guard: prevent index going below 0
if (currentIndex.value <= 0) return;
```

---

## 8. Master AI Prompt for Code Generation

> Copy and paste the entire block below into your AI coding assistant to generate the complete Flutter project.

```
▶ MASTER PROMPT — START COPYING FROM HERE

You are an expert Flutter developer. Build a complete, production-quality
Flutter flashcard quiz mobile app called "FlashMind". Follow ALL instructions
exactly with zero shortcuts.

─── ARCHITECTURE REQUIREMENTS ───
- Pattern: MVVM — strictly no business logic in View files
- State Management: GetX — use Rx observables, Obx(), GetxController, Bindings, Get.lazyPut()
- Dependency Injection: All controllers injected via GetX Binding classes
- Navigation: GetX named routes only (Get.toNamed, Get.back) — never use Navigator directly
- Storage: GetStorage for local persistence — no Firebase, no SQLite, no shared_preferences
- Clean Code: Single Responsibility Principle per class; no file exceeds 150 lines

─── FOLDER STRUCTURE ───
Generate ALL files exactly in this structure:
lib/main.dart
lib/app/app.dart
lib/app/routes/app_routes.dart
lib/app/routes/app_pages.dart
lib/app/bindings/home_binding.dart
lib/app/bindings/manage_binding.dart
lib/app/theme/app_theme.dart
lib/data/models/flashcard.dart
lib/data/repositories/flashcard_repository.dart
lib/data/services/storage_service.dart
lib/features/home/home_screen.dart
lib/features/home/home_controller.dart
lib/features/home/widgets/flip_card.dart
lib/features/home/widgets/nav_buttons.dart
lib/features/manage/manage_screen.dart
lib/features/manage/manage_controller.dart
lib/features/manage/widgets/card_list_item.dart
lib/features/manage/widgets/card_form_sheet.dart
lib/core/constants/app_constants.dart
lib/core/utils/validators.dart
pubspec.yaml

─── COMMENTING REQUIREMENTS ───
EVERY single file MUST have:
1. File-level doc comment: file name, purpose, dependencies, pattern used
2. Class-level doc comment: what it does, what it owns, which MVVM layer
3. Every public method: doc comment with params, return value, side effects
4. Every Rx variable: inline comment explaining what it tracks
5. Every non-trivial block: single-line comment explaining the WHY
6. All guard clauses: comment explaining the edge case

─── FEATURE SPECS ───
- Home Screen: Flashcard flip animation (3D Y-axis, 400ms), Show Answer button,
  Previous/Next navigation, card counter "X of Y", disabled state for boundary
  cards, empty state widget
- Manage Screen: Scrollable card list, live search filter, Add/Edit/Delete
  operations, swipe-to-delete with confirmation dialog, FAB button
- Card Form: Bottom sheet (not full screen), Question field (max 300 chars,
  multiline, counter), Answer field (max 500 chars, multiline, counter),
  validation on empty, Save/Cancel buttons
- Data: Flashcard model with id (UUID), question, answer, createdAt;
  JSON serialization; GetStorage persistence under key "flashcards"

─── UI / THEME SPECS ───
- Primary: #1565C0 | Accent: #42A5F5 | Background: #F5F7FA
- Card surface: #FFFFFF, 12px border radius, elevation shadow
- Card back face: #E3F2FD (light blue tint) to distinguish answer side
- Typography: Google Fonts "Poppins"
- Buttons: BorderRadius.circular(12), proper disabled styling
- AppBar: no elevation, white background, dark title text

─── ANIMATION SPECS ───
- AnimationController duration 400ms, CurvedAnimation Curves.easeInOut
- Transform with Matrix4.rotationY() for 3D effect
- Hide back content at >90 degrees to prevent mirror-image text
- Flip resets to question side on every card navigation

─── pubspec.yaml REQUIREMENTS ───
- dependencies: flutter, get, get_storage, uuid, google_fonts
- dev_dependencies: flutter_test, flutter_lints
- Include assets section even if empty

─── OUTPUT FORMAT ───
For EACH file:
1. Start with: // ═══ FILE: lib/path/to/file.dart ═══
2. Full complete Dart code — no placeholders, no "// TODO", no truncation
3. Every method fully implemented — no empty bodies
4. File ends with a blank line

After all files, output "Setup Instructions":
1. flutter pub get
2. Run on iOS simulator and Android emulator
3. Build release APK

◀ MASTER PROMPT — END OF COPY
```

---

## 9. Acceptance Criteria & QA Checklist

### 9.1 Architecture Checks
- [ ] No logic code inside any `*_screen.dart` View file
- [ ] All state variables are RxType (`RxList`, `RxInt`, `RxBool`, etc.)
- [ ] All screens use `Obx()` for reactive rebuilds
- [ ] All controllers registered via Binding classes
- [ ] All navigation uses `Get.toNamed()` or `Get.back()`
- [ ] Repository pattern abstracted (interface + implementation)

### 9.2 Feature Checks
- [ ] Card flip animation works smoothly (no jitter, no mirror text)
- [ ] Show Answer button triggers flip
- [ ] Previous disabled on first card, Next disabled on last card
- [ ] Card counter updates correctly on navigation
- [ ] Add card persists after app restart (GetStorage working)
- [ ] Edit pre-fills form fields correctly
- [ ] Delete shows confirmation dialog
- [ ] Search filters cards in real time
- [ ] Empty state shows when deck has no cards

### 9.3 Code Quality Checks
- [ ] Every file has a file-level doc comment
- [ ] Every public method has a doc comment
- [ ] Every Rx variable has an inline comment
- [ ] No file exceeds 150 lines
- [ ] `pubspec.yaml` includes all required packages
- [ ] `flutter analyze` passes with 0 errors

---

## 10. Suggested Development Timeline

| Sprint | Duration   | Deliverable                             | Status     |
|--------|------------|-----------------------------------------|------------|
| 1      | Day 1–2    | Project setup, folder structure, theme  | 🔲 Pending |
| 2      | Day 3–4    | Data model, repository, storage service | 🔲 Pending |
| 3      | Day 5–6    | Home screen + card flip animation       | 🔲 Pending |
| 4      | Day 7–8    | Manage screen + CRUD operations         | 🔲 Pending |
| 5      | Day 9–10   | Form validation, search, edge cases     | 🔲 Pending |
| 6      | Day 11–12  | UI polish, testing, bug fixes           | 🔲 Pending |

---

*FlashMind PRD v1.0 · Generated March 2026*

---
---

# 🤖 Prompt for AI: Analyze This PRD & Generate Complete Implementation Plan

> **How to use:** Attach this `.md` file to a new conversation with Claude (or any AI), then copy-paste the prompt block below. The AI will read the full PRD above and produce a phase-by-phase implementation plan.

---

```
════════════════════════════════════════════════════════════════
  FLASHMIND — IMPLEMENTATION PLAN GENERATION PROMPT
  For: Claude / ChatGPT / Cursor / Any LLM
════════════════════════════════════════════════════════════════

You are a senior Flutter engineer and technical architect.
I have attached a complete Product Requirements Document (PRD)
for a Flutter mobile app called "FlashMind". READ the entire
PRD carefully before responding.

Your task is to produce a COMPLETE, DETAILED IMPLEMENTATION PLAN.
Do NOT generate any Dart code yet — only the plan. It must be
exhaustive enough that a junior developer could follow it
step-by-step without ambiguity.

════ STRUCTURE YOUR RESPONSE EXACTLY AS FOLLOWS ════

---

## PHASE 0 — Environment Setup
- Every tool to install (Flutter SDK, Dart, Android Studio / Xcode,
  VS Code extensions) with exact version requirements
- Complete pubspec.yaml file (write it in full)
- Verify commands: flutter doctor, flutter run

---

## PHASE 1 — Project Scaffold
- Exact flutter create command with all flags
- How to remove default counter boilerplate
- Every mkdir command to create the folder structure from PRD §3.2
- Confirm final structure matches PRD exactly

---

## PHASE 2 — Core Layer (no UI — implement first)
For each file in lib/core/ and lib/data/, provide:
  • Full file path
  • Purpose in 1–2 sentences
  • All class/function signatures (names + params, no body)
  • Imports it will need
  • Creation order (dependency graph — what it needs to exist first)
  • Estimated lines of code

Files to plan:
  lib/core/constants/app_constants.dart
  lib/core/utils/validators.dart
  lib/data/models/flashcard.dart
  lib/data/services/storage_service.dart  (interface + impl)
  lib/data/repositories/flashcard_repository.dart  (interface + impl)

---

## PHASE 3 — App Configuration Layer
For each file in lib/app/, provide the same detail as Phase 2, plus:

  lib/app/theme/app_theme.dart
    → Every ThemeData property to configure
    → Exact hex values from PRD §5.1

  lib/app/routes/app_routes.dart
    → All route name constants to define

  lib/app/routes/app_pages.dart
    → All GetPage entries with their bindings

  lib/app/bindings/home_binding.dart
    → What gets registered and in what order

  lib/app/bindings/manage_binding.dart
    → What gets registered and in what order

  lib/app/app.dart
    → GetMaterialApp config checklist

  lib/main.dart
    → Exact initialization sequence (GetStorage.init, runApp, etc.)

---

## PHASE 4 — Feature: Home / Quiz Screen
Plan every file for this feature:

  lib/features/home/home_controller.dart
    → Every Rx variable: type, name, purpose, what rebuilds on change
    → Every method: signature + what it does + side effects
    → Every computed getter
    → Card navigation logic (boundary handling in detail)
    → How and when flip state resets

  lib/features/home/widgets/flip_card.dart
    → AnimationController and CurvedAnimation setup
    → Matrix4.rotationY() logic for front/back faces
    → How to conditionally show front vs back by rotation angle
    → Required widget parameters

  lib/features/home/widgets/nav_buttons.dart
    → Required parameters
    → Disabled state logic and styling

  lib/features/home/home_screen.dart
    → Which widgets need Obx() and exactly why
    → Empty state condition and what to render
    → Full layout structure (widget tree outline)

---

## PHASE 5 — Feature: Manage Deck Screen
Plan every file for this feature:

  lib/features/manage/manage_controller.dart
    → Every Rx variable with purpose
    → Add flow: validation → model creation → repo call → list update
    → Edit flow: pre-fill → validate → repo call → list update
    → Delete flow: confirmation → repo call → list update
    → Search/filter logic: how filtered list derives from full list

  lib/features/manage/widgets/card_form_sheet.dart
    → TextEditingController lifecycle (init, pre-fill, dispose)
    → How Add vs Edit mode is passed and handled
    → Validation trigger on Save tap

  lib/features/manage/widgets/card_list_item.dart
    → Required parameters (Flashcard model, callbacks)

  lib/features/manage/manage_screen.dart
    → Search field setup (controller, onChanged wiring)
    → ListView.builder setup
    → Dismissible swipe-to-delete configuration
    → FAB behavior

---

## PHASE 6 — Wiring & Integration
- How HomeController loads cards from repo in onInit()
- How ManageController changes are reflected in HomeController
  (GetX cross-controller communication strategy)
- GetStorage init sequence relative to runApp
- Full navigation flow (text diagram):
  App Start → Home → tap Manage icon → Manage Screen → Back → Home

---

## PHASE 7 — QA & Testing Plan
For each item in PRD §9 (Acceptance Criteria), specify:
  - How to manually test it on the emulator
  - Pass/fail condition
  - Edge cases beyond the checklist

---

## PHASE 8 — Build & Release
- flutter analyze: expected clean output
- flutter test: list test file names and what each tests
- flutter build apk --release: step-by-step
- flutter build ios: prerequisites
- How to test on physical device (Android + iOS)

---

## IMPLEMENTATION ORDER — MASTER FILE LIST
Numbered list of ALL 21 files in exact creation order.
For each: file path + one sentence explaining why it comes
at that position (what dependency it satisfies).

════ CONSTRAINTS ════
- Do NOT write any Dart code — plans, signatures, and rationale only.
- Every section must be self-contained — do not reference the PRD
  with "see §X"; restate the relevant detail inline.
- Flag any ambiguities or gaps you find in the PRD and
  propose resolutions before the phases begin.
- End with: total estimated lines of code for the project,
  and the 3 most technically challenging parts with explanation.

Start your response with the header:
  IMPLEMENTATION PLAN — FlashMind v1.0
followed by a short paragraph confirming your understanding
of the app before the phases begin.
════════════════════════════════════════════════════════════════
```

---

*End of FlashMind PRD + AI Prompts · v1.0 · March 2026*
