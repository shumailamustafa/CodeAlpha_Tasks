# IMPLEMENTATION PLAN — FlashMind v1.0

FlashMind is a cross-platform Flutter mobile flashcard quiz application following MVVM + GetX architecture. It has **two screens** — a Home/Quiz screen with 3D card flip animations and a Manage Deck screen for full CRUD operations. Data persists locally via GetStorage. The app targets students, language learners, and professionals who need a distraction-free study tool. This plan covers all 21 source files across 8 phases.

---

## PRD Ambiguities & Proposed Resolutions

| # | Ambiguity | Resolution |
|---|-----------|------------|
| 1 | PRD lists both GetStorage and Hive as storage options (§1.4) but all code examples use GetStorage exclusively | **Use GetStorage only.** Hive is a V2 consideration if needed. |
| 2 | PRD §2.1 F-02 says FAB is on Home screen for adding cards, but F-05 also puts a FAB on Manage screen for adding | **FAB on Manage screen only.** Home screen has the "Manage Deck" icon button in AppBar to navigate. This avoids UX confusion. |
| 3 | PRD §2.1 F-03 says "Long-press or Edit icon" — unclear if long-press is on Home (quiz card) or Manage (list item) | **Long-press only on Manage screen list items.** Home screen has no edit capability — it's purely for studying. Edit icon buttons also appear on each list item in Manage screen. |
| 4 | PRD mentions `uuid` package for ID generation but doesn't specify version | **Use `uuid: ^4.0.0`** (latest stable compatible with Dart 3) |
| 5 | PRD §5.2 mentions Google Fonts "Poppins" but doesn't specify font weights | **Use Poppins: 400 (regular), 500 (medium), 600 (semiBold), 700 (bold)** |
| 6 | PRD says "no file exceeds 150 lines" — this may be tight for some controllers | **Target 150 lines but allow up to ~160 if needed for completeness with comments.** Extract helpers to keep files lean. |
| 7 | PRD doesn't specify Dart/Flutter minimum SDK versions | **Use Flutter 3.22+ / Dart SDK >=3.3.0 <4.0.0** |

---

## PHASE 0 — Environment Setup

### Tools to Install

| Tool | Version | Purpose |
|------|---------|---------|
| Flutter SDK | 3.22.x or later (stable channel) | Framework |
| Dart SDK | ≥3.3.0 (bundled with Flutter) | Language |
| Android Studio | 2024.1+ (Ladybug) | Android build toolchain, emulator |
| Xcode | 15.0+ (macOS only) | iOS build toolchain, simulator |
| VS Code | Latest | Editor |
| VS Code Extensions | Dart, Flutter, Flutter Widget Snippets, GetX Snippets | Productivity |
| Git | Latest | Version control |

### Complete `pubspec.yaml`

```yaml
name: flashmind
description: A cross-platform Flutter flashcard quiz app for focused learning.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  get_storage: ^2.1.1
  uuid: ^4.3.3
  google_fonts: ^6.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

flutter:
  uses-material-design: true
  assets: []
```

#### Phase 7: UI/UX Enhancement [NEW]
- Implement sliding card navigation with `PageView`.
- Enhance flashcard visual design (gradients, shadows, premium typography).
- Synchronize navigation buttons with the sliding gestures.

### Verification Commands

1. `flutter doctor` — All checks must pass (green ✓) for target platforms
2. `flutter pub get` — All dependencies resolve
3. `flutter run` — App launches on emulator/simulator (after scaffold phase)

---

## PHASE 1 — Project Scaffold

### Project Creation

```
flutter create --org com.flashmind --project-name flashmind --platforms android,ios .
```

### Remove Default Boilerplate

- Delete the entire contents of `lib/main.dart` (counter app code)
- Delete `test/widget_test.dart`

### Directory Creation Commands (from project root)

```
mkdir lib\app
mkdir lib\app\routes
mkdir lib\app\bindings
mkdir lib\app\theme
mkdir lib\data
mkdir lib\data\models
mkdir lib\data\repositories
mkdir lib\data\services
mkdir lib\features
mkdir lib\features\home
mkdir lib\features\home\widgets
mkdir lib\features\manage
mkdir lib\features\manage\widgets
mkdir lib\core
mkdir lib\core\constants
mkdir lib\core\utils
```

### Final Folder Verification

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   ├── bindings/
│   │   ├── home_binding.dart
│   │   └── manage_binding.dart
│   └── theme/
│       └── app_theme.dart
├── data/
│   ├── models/
│   │   └── flashcard.dart
│   ├── repositories/
│   │   └── flashcard_repository.dart
│   └── services/
│       └── storage_service.dart
├── features/
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── home_controller.dart
│   │   └── widgets/
│   │       ├── flip_card.dart
│   │       └── nav_buttons.dart
│   └── manage/
│       ├── manage_screen.dart
│       ├── manage_controller.dart
│       └── widgets/
│           ├── card_list_item.dart
│           └── card_form_sheet.dart
└── core/
    ├── constants/
    │   └── app_constants.dart
    └── utils/
        └── validators.dart
```

Total: **21 files** (20 `.dart` + 1 `pubspec.yaml`)

---

## PHASE 2 — Core Layer (No UI — Implement First)

### File 1: `lib/core/constants/app_constants.dart`

- **Purpose**: Centralized storage keys, character limits, and default values used across the app.
- **Dependencies**: None (leaf node — create first)
- **Imports**: None

| Signature | Description |
|-----------|-------------|
| `class AppConstants` | Abstract class with static constants |
| `static const String storageKey = 'flashcards'` | GetStorage key for the flashcard JSON array |
| `static const int questionMaxLength = 300` | Max chars for question field |
| `static const int answerMaxLength = 500` | Max chars for answer field |
| `static const Duration flipDuration = Duration(milliseconds: 400)` | Card flip animation duration |
| `static const String appTitle = 'FlashMind 📚'` | App bar title |
| `static const String manageDeckTitle = 'Manage Deck'` | Manage screen title |

- **Estimated LOC**: ~30

---

### File 2: `lib/core/utils/validators.dart`

- **Purpose**: Form validation helper functions for question and answer text fields. Returns error string or null.
- **Dependencies**: `app_constants.dart` (for max length values)
- **Imports**: `app_constants.dart`

| Signature | Description |
|-----------|-------------|
| `class Validators` | Abstract class with static methods |
| `static String? validateQuestion(String? value)` | Returns error if null, empty, or exceeds 300 chars |
| `static String? validateAnswer(String? value)` | Returns error if null, empty, or exceeds 500 chars |

- **Estimated LOC**: ~35

---

### File 3: `lib/data/models/flashcard.dart`

- **Purpose**: Data model representing a single flashcard with id, question, answer, and createdAt. Includes JSON serialization for GetStorage persistence.
- **Dependencies**: None (standalone model)
- **Imports**: `dart:convert` (implicit via JSON usage)

| Signature | Description |
|-----------|-------------|
| `class Flashcard` | Immutable flashcard data class |
| `Flashcard({required this.id, required this.question, required this.answer, required this.createdAt})` | Constructor |
| `factory Flashcard.fromJson(Map<String, dynamic> json)` | Deserialize from JSON map |
| `Map<String, dynamic> toJson()` | Serialize to JSON map |
| `Flashcard copyWith({String? question, String? answer})` | Create a copy with optional field overrides |
| `@override bool operator ==(Object other)` | Value equality on `id` |
| `@override int get hashCode` | Hash based on `id` |

**Fields:**
- `final String id` — UUID v4 unique identifier
- `final String question` — Front of card (max 300 chars)
- `final String answer` — Back of card (max 500 chars)
- `final DateTime createdAt` — Timestamp for ordering

- **Estimated LOC**: ~55

---

### File 4: `lib/data/services/storage_service.dart`

- **Purpose**: Abstraction over GetStorage. Provides an interface + implementation for reading/writing the flashcard JSON list to local storage.
- **Dependencies**: `flashcard.dart`, `app_constants.dart`
- **Imports**: `get_storage/get_storage.dart`, `flashcard.dart`, `app_constants.dart`

| Signature | Description |
|-----------|-------------|
| `abstract class StorageService` | Interface for storage operations |
| `List<Flashcard> readAll()` | Read all flashcards from storage |
| `void writeAll(List<Flashcard> cards)` | Write entire flashcard list to storage |
| `class StorageServiceImpl implements StorageService` | Concrete GetStorage implementation |
| `final GetStorage _box` | GetStorage instance |
| `StorageServiceImpl()` | Constructor — initializes `_box = GetStorage()` |
| `@override List<Flashcard> readAll()` | Reads JSON array from key `'flashcards'`, deserializes |
| `@override void writeAll(List<Flashcard> cards)` | Serializes list to JSON, writes under key `'flashcards'` |

- **Estimated LOC**: ~55

---

### File 5: `lib/data/repositories/flashcard_repository.dart`

- **Purpose**: Data access abstraction layer implementing CRUD operations for flashcards. Delegates persistence to StorageService.
- **Dependencies**: `flashcard.dart`, `storage_service.dart`
- **Imports**: `flashcard.dart`, `storage_service.dart`, `uuid/uuid.dart`

| Signature | Description |
|-----------|-------------|
| `abstract class FlashcardRepository` | Interface for CRUD operations |
| `List<Flashcard> getAllCards()` | Retrieve all flashcards |
| `void addCard(String question, String answer)` | Create new flashcard with UUID |
| `void updateCard(String id, String question, String answer)` | Update existing card by id |
| `void deleteCard(String id)` | Remove card by id |
| `class FlashcardRepositoryImpl implements FlashcardRepository` | Concrete implementation |
| `final StorageService _storageService` | Injected storage dependency |
| `FlashcardRepositoryImpl(this._storageService)` | Constructor |

**Implementation details:**
- `addCard`: generates UUID v4, creates `Flashcard` with `DateTime.now()`, appends to list, calls `writeAll`
- `updateCard`: finds card by id, replaces with `copyWith(...)`, calls `writeAll`
- `deleteCard`: filters card out by id, calls `writeAll`

- **Estimated LOC**: ~70

---

### Phase 2 Dependency Graph (Creation Order)

```
app_constants.dart ──┐
                     ├──► validators.dart
                     │
flashcard.dart ──────┤
                     ├──► storage_service.dart ──► flashcard_repository.dart
                     │
```

**Order**: `app_constants` → `flashcard` → `validators` → `storage_service` → `flashcard_repository`

---

## PHASE 3 — App Configuration Layer

### File 6: `lib/app/theme/app_theme.dart`

- **Purpose**: Centralized ThemeData configuration. Defines all colors, fonts, button styles, and component themes per the design spec.
- **Dependencies**: `google_fonts`
- **Imports**: `flutter/material.dart`, `google_fonts/google_fonts.dart`

| Signature | Description |
|-----------|-------------|
| `class AppTheme` | Abstract class, static theme members |
| `static const Color primary = Color(0xFF1565C0)` | Buttons, headings, FAB |
| `static const Color accent = Color(0xFF42A5F5)` | Card borders, active states |
| `static const Color background = Color(0xFFF5F7FA)` | Screen backgrounds |
| `static const Color cardSurface = Color(0xFFFFFFFF)` | Flashcard front face |
| `static const Color cardBack = Color(0xFFE3F2FD)` | Flashcard answer side |
| `static const Color error = Color(0xFFD32F2F)` | Validation error messages |
| `static ThemeData get lightTheme` | Returns fully configured ThemeData |

**ThemeData properties to configure:**
- `colorScheme`: built from `primary`, with surface/background overrides
- `scaffoldBackgroundColor`: `#F5F7FA`
- `appBarTheme`: no elevation, white background, dark text, Poppins font
- `textTheme`: Poppins with various weights via `GoogleFonts.poppinsTextTheme()`
- `elevatedButtonTheme`: `#1565C0` background, white text, `BorderRadius.circular(12)`
- `outlinedButtonTheme`: `#1565C0` border, `BorderRadius.circular(12)`, proper disabled styling (grayed out)
- `floatingActionButtonTheme`: `#1565C0` background, white icon
- `inputDecorationTheme`: rounded borders, focus color `#42A5F5`
- `cardTheme`: `#FFFFFF` surface, 12px border radius, elevation shadow
- `dialogTheme`: rounded corners

- **Estimated LOC**: ~80

---

### File 7: `lib/app/routes/app_routes.dart`

- **Purpose**: Static route name constants used throughout the app for navigation.
- **Dependencies**: None
- **Imports**: None

| Signature | Description |
|-----------|-------------|
| `abstract class Routes` | Route name constants |
| `static const String HOME = '/'` | Home/Quiz screen route |
| `static const String MANAGE = '/manage'` | Manage Deck screen route |

- **Estimated LOC**: ~12

---

### File 8: `lib/app/routes/app_pages.dart`

- **Purpose**: Master list of all GetPage route definitions with their bindings.
- **Dependencies**: `app_routes.dart`, all screen files, all binding files
- **Imports**: `get/get.dart`, `app_routes.dart`, `home_screen.dart`, `manage_screen.dart`, `home_binding.dart`, `manage_binding.dart`

| Signature | Description |
|-----------|-------------|
| `class AppPages` | Route configuration class |
| `static const INITIAL = Routes.HOME` | Initial route on app launch |
| `static final List<GetPage> routes` | All route definitions |

**GetPage entries:**

| Route | Page | Binding |
|-------|------|---------|
| `Routes.HOME` | `HomeScreen()` | `HomeBinding()` |
| `Routes.MANAGE` | `ManageScreen()` | `ManageBinding()` |

- **Estimated LOC**: ~25

---

### File 9: `lib/app/bindings/home_binding.dart`

- **Purpose**: Registers all dependencies needed by the Home/Quiz screen into the GetX DI container.
- **Dependencies**: `storage_service.dart`, `flashcard_repository.dart`, `home_controller.dart`
- **Imports**: `get/get.dart`, service/repo/controller files

| Signature | Description |
|-----------|-------------|
| `class HomeBinding extends Bindings` | GetX binding class |
| `@override void dependencies()` | Registers dependencies |

**Registration order (matters for `Get.find()` resolution):**
1. `Get.lazyPut<StorageService>(() => StorageServiceImpl())` — storage layer first
2. `Get.lazyPut<FlashcardRepository>(() => FlashcardRepositoryImpl(Get.find()))` — repo depends on service
3. `Get.lazyPut<HomeController>(() => HomeController(Get.find()))` — controller depends on repo

- **Estimated LOC**: ~22

---

### File 10: `lib/app/bindings/manage_binding.dart`

- **Purpose**: Registers dependencies for the Manage Deck screen.
- **Dependencies**: `manage_controller.dart`, `flashcard_repository.dart`
- **Imports**: `get/get.dart`, controller/repo files

| Signature | Description |
|-----------|-------------|
| `class ManageBinding extends Bindings` | GetX binding class |
| `@override void dependencies()` | Registers dependencies |

**Registration order:**
1. `Get.lazyPut<ManageController>(() => ManageController(Get.find()))` — repo is already registered from HomeBinding (it's still in memory since Home screen isn't disposed)

- **Estimated LOC**: ~18

---

### File 11: `lib/app/app.dart`

- **Purpose**: Root widget wrapping the app in `GetMaterialApp` with all configuration.
- **Dependencies**: `app_theme.dart`, `app_pages.dart`, `app_routes.dart`
- **Imports**: `get/get.dart`, `app_theme.dart`, `app_pages.dart`

| Signature | Description |
|-----------|-------------|
| `class FlashMindApp extends StatelessWidget` | Root app widget |
| `@override Widget build(BuildContext context)` | Returns GetMaterialApp |

**GetMaterialApp configuration checklist:**
- `title: 'FlashMind'`
- `debugShowCheckedModeBanner: false`
- `theme: AppTheme.lightTheme`
- `initialRoute: AppPages.INITIAL` (which is `Routes.HOME`)
- `getPages: AppPages.routes` (list of all GetPage entries)
- `defaultTransition: Transition.fadeIn` (smooth screen transitions)

- **Estimated LOC**: ~25

---

### File 12: `lib/main.dart`

- **Purpose**: App entry point. Initializes async services before running the app.
- **Dependencies**: `app.dart`, `get_storage`
- **Imports**: `flutter/material.dart`, `get_storage/get_storage.dart`, `app.dart`

| Signature | Description |
|-----------|-------------|
| `Future<void> main() async` | Entry point |

**Initialization sequence (exact order):**
1. `WidgetsFlutterBinding.ensureInitialized()` — required before any async operations
2. `await GetStorage.init()` — initialize local storage container
3. `runApp(const FlashMindApp())` — launch the app tree

- **Estimated LOC**: ~15

---

## PHASE 4 — Feature: Home / Quiz Screen

### File 13: `lib/features/home/home_controller.dart`

- **Purpose**: ViewModel for the Home/Quiz screen. Manages the current card index, flip state, and deck navigation. Loads cards from repository on initialization.
- **Dependencies**: `flashcard_repository.dart`, `flashcard.dart`
- **Imports**: `get/get.dart`, `flashcard.dart`, `flashcard_repository.dart`

#### Rx Variables

| Type | Name | Purpose | What Rebuilds |
|------|------|---------|--------------|
| `RxList<Flashcard>` | `cards` | All flashcards in the deck | Quiz UI, counter, empty state |
| `RxInt` | `currentIndex` | Index of currently displayed card | Card content, counter, nav button states |
| `RxBool` | `isFlipped` | Whether card is showing answer side | FlipCard widget animation state |

#### Computed Getters

| Getter | Return Type | Logic |
|--------|-------------|-------|
| `hasPrevious` | `bool` | `currentIndex.value > 0` |
| `hasNext` | `bool` | `currentIndex.value < cards.length - 1` |
| `currentCard` | `Flashcard?` | `cards.isEmpty ? null : cards[currentIndex.value]` |

#### Methods

| Signature | What It Does | Side Effects |
|-----------|-------------|--------------|
| `@override void onInit()` | Calls `loadCards()`, then `super.onInit()` | Triggers initial data fetch |
| `void loadCards()` | Fetches all cards from repo, assigns to `cards` | Resets `currentIndex` to 0, resets `isFlipped` to false |
| `void nextCard()` | Increments `currentIndex` if `hasNext` is true | Resets `isFlipped` to false (question side shows) |
| `void previousCard()` | Decrements `currentIndex` if `hasPrevious` is true | Resets `isFlipped` to false |
| `void toggleFlip()` | Toggles `isFlipped` value | Triggers flip animation in view |
| `void refreshCards()` | Re-reads cards from repo (called when returning from Manage) | Resets index to 0 if deck changed, resets flip |

**Card Navigation Boundary Handling:**
- `nextCard()`: guard — `if (!hasNext) return;` — prevents index exceeding `cards.length - 1`
- `previousCard()`: guard — `if (!hasPrevious) return;` — prevents index going below 0
- Both methods **always** reset `isFlipped.value = false` so the next card shows question side first
- If `cards` becomes empty (all deleted), `currentCard` returns null, triggering empty state

- **Estimated LOC**: ~75

---

### File 14: `lib/features/home/widgets/flip_card.dart`

- **Purpose**: Animated 3D flip card widget using Y-axis rotation. Shows question on front, answer on back.
- **Dependencies**: `app_theme.dart`
- **Imports**: `flutter/material.dart`, `dart:math` (for pi), `app_theme.dart`

#### Widget Parameters

| Parameter | Type | Purpose |
|-----------|------|---------|
| `question` | `String` | Text for front face |
| `answer` | `String` | Text for back face |
| `isFlipped` | `bool` | Current flip state from controller |
| `onFlip` | `VoidCallback` | Callback to toggle flip in controller |

#### Animation Setup

- **StatefulWidget** with `SingleTickerProviderStateMixin`
- `AnimationController`: `duration: 400ms`, `vsync: this`
- `CurvedAnimation`: `parent: _controller`, `curve: Curves.easeInOut`
- Listen to `widget.isFlipped` changes via `didUpdateWidget()`:
  - If `isFlipped == true` → `_controller.forward()`
  - If `isFlipped == false` → `_controller.reverse()`

#### 3D Rotation Logic

- `AnimatedBuilder` wraps the card
- `Transform` with `Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(_animation.value * pi)`
- **Front face**: visible when `_animation.value < 0.5` (angle < 90°)
  - Shows "QUESTION" label at top, question text centered
  - Background: `#FFFFFF` (cardSurface)
- **Back face**: visible when `_animation.value >= 0.5` (angle ≥ 90°)
  - Apply additional `rotateY(pi)` to prevent mirror-image text
  - Shows "ANSWER" label at top, answer text centered
  - Background: `#E3F2FD` (cardBack)
- Card container: `BorderRadius.circular(12)`, elevation shadow, padding

#### "Show Answer" Button

- `ElevatedButton` below the card
- Label: `"Show Answer"` when not flipped, `"Show Question"` when flipped
- `onPressed` calls the `onFlip` callback

- **Estimated LOC**: ~120

---

### File 15: `lib/features/home/widgets/nav_buttons.dart`

- **Purpose**: Bottom navigation row with Previous/Next buttons and card counter text.
- **Dependencies**: `app_theme.dart`
- **Imports**: `flutter/material.dart`, `app_theme.dart`

#### Required Parameters

| Parameter | Type | Purpose |
|-----------|------|---------|
| `currentIndex` | `int` | Current card position (0-based) |
| `totalCards` | `int` | Total number of cards |
| `hasPrevious` | `bool` | Whether Previous button is enabled |
| `hasNext` | `bool` | Whether Next button is enabled |
| `onPrevious` | `VoidCallback` | Calls `controller.previousCard()` |
| `onNext` | `VoidCallback` | Calls `controller.nextCard()` |

#### Disabled State Logic

- Previous button: `onPressed: hasPrevious ? onPrevious : null`
  - When disabled: grayed-out text and border (theme's `disabledColor`)
  - Visual: `OutlinedButton` with `← Previous` text
- Next button: `onPressed: hasNext ? onNext : null`
  - When disabled: grayed-out  
  - Visual: `OutlinedButton` with `Next →` text
- Counter text: `"Card ${currentIndex + 1} of $totalCards"` — centered between buttons

#### Layout

- `Row` with `MainAxisAlignment.spaceBetween`
- Structure: `[← Previous] [Card X of Y] [Next →]`

- **Estimated LOC**: ~55

---

### File 16: `lib/features/home/home_screen.dart`

- **Purpose**: View for the Home/Quiz screen. Purely declarative — observes HomeController's reactive state.
- **Dependencies**: `home_controller.dart`, `flip_card.dart`, `nav_buttons.dart`, `app_routes.dart`
- **Imports**: `flutter/material.dart`, `get/get.dart`, all widget/controller files

#### Widget Tree Outline

```
GetView<HomeController>
└── Scaffold
    ├── AppBar
    │   ├── title: "FlashMind 📚"
    │   └── actions: [IconButton(icon: Icons.list_alt, onPressed: → navigate to Manage)]
    └── body: Obx(() =>  ← wraps entire body to react to card changes
        controller.cards.isEmpty
        ? EmptyStateWidget  ← Center column: icon + "No flashcards yet" text + instructions
        : Column
            ├── Expanded
            │   └── Center
            │       └── FlipCard(
            │           question: controller.currentCard!.question,
            │           answer: controller.currentCard!.answer,
            │           isFlipped: controller.isFlipped.value,
            │           onFlip: controller.toggleFlip,
            │       )
            └── Padding
                └── NavButtons(
                    currentIndex: controller.currentIndex.value,
                    totalCards: controller.cards.length,
                    hasPrevious: controller.hasPrevious,
                    hasNext: controller.hasNext,
                    onPrevious: controller.previousCard,
                    onNext: controller.nextCard,
                )
    )
```

#### Obx() Placement & Rationale

- **Single `Obx()` wrapping body**: Rebuilds on `cards`, `currentIndex`, and `isFlipped` changes. Since these are tightly coupled (any nav change affects everything), a single Obx is simpler and avoids nesting complexity.
- **Alternative approach** (if performance matters): nested `Obx()` on FlipCard and NavButtons separately. Not necessary at this scale.

#### Empty State

- **Condition**: `controller.cards.isEmpty`
- **Render**: `Column(center)` → large icon (`Icons.school`), `Text("No flashcards yet")`, `Text("Go to Manage Deck to add some cards!")`

#### Navigation to Manage

- AppBar action button: `Get.toNamed(Routes.MANAGE)?.then((_) => controller.refreshCards())`
- Uses `.then()` to refresh cards when returning from Manage screen

- **Estimated LOC**: ~75

---

## PHASE 5 — Feature: Manage Deck Screen

### File 17: `lib/features/manage/manage_controller.dart`

- **Purpose**: ViewModel for the Manage Deck screen. Handles all CRUD operations, search/filter, and delegates to the repository.
- **Dependencies**: `flashcard_repository.dart`, `flashcard.dart`, `validators.dart`
- **Imports**: `get/get.dart`, `flashcard.dart`, `flashcard_repository.dart`

#### Rx Variables

| Type | Name | Purpose |
|------|------|---------|
| `RxList<Flashcard>` | `allCards` | Complete unfiltered card list |
| `RxList<Flashcard>` | `filteredCards` | Cards matching current search query |
| `RxString` | `searchQuery` | Current search text |

#### Methods

| Signature | What It Does |
|-----------|-------------|
| `@override void onInit()` | Loads all cards from repo, sets `filteredCards = allCards`, calls `super.onInit()` |
| `void loadCards()` | Fetches all cards from repo, assigns to `allCards`, applies current filter |
| `void searchCards(String query)` | Sets `searchQuery`, filters `allCards` where question or answer contains query (case-insensitive), assigns result to `filteredCards` |
| `void addCard(String question, String answer)` | Calls `_repo.addCard(question, answer)`, then `loadCards()` to refresh |
| `void updateCard(String id, String question, String answer)` | Calls `_repo.updateCard(id, question, answer)`, then `loadCards()` |
| `void deleteCard(String id)` | Calls `_repo.deleteCard(id)`, then `loadCards()` |
| `void _applyFilter()` | Internal helper: filters `allCards` by `searchQuery` and updates `filteredCards` |

#### Add Flow

1. User taps FAB → `CardFormSheet` opens in **Add mode** (empty fields)
2. User fills question/answer → taps "Save"
3. Sheet validates with `Validators.validateQuestion()` and `Validators.validateAnswer()`
4. If valid: calls `controller.addCard(question, answer)`
5. Controller calls repo → repo generates UUID, creates model, persists via StorageService
6. Controller reloads cards → filtered list updates → UI rebuilds
7. Sheet dismisses

#### Edit Flow

1. User taps pencil icon on list item → `CardFormSheet` opens in **Edit mode** (pre-filled)
2. Existing `Flashcard` object is passed to the sheet
3. `TextEditingController`s are initialized with existing question/answer text
4. User modifies → taps "Update"
5. Validation runs → if valid: calls `controller.updateCard(id, newQuestion, newAnswer)`
6. Controller calls repo → repo finds card by id, replaces values, persists
7. Controller reloads → UI rebuilds
8. Sheet dismisses

#### Delete Flow

1. User taps trash icon (or swipes-to-dismiss) on list item
2. Confirmation dialog shown: "Delete this flashcard? This cannot be undone."
3. User confirms → calls `controller.deleteCard(id)`
4. Controller calls repo → repo filters card out, persists
5. Controller reloads → UI rebuilds
6. If last card deleted → `filteredCards` becomes empty → empty state shows

#### Search/Filter Logic

- `searchCards(String query)` is called on every `onChanged` of the search TextField
- Filter: `allCards.where((card) => card.question.toLowerCase().contains(query.toLowerCase()) || card.answer.toLowerCase().contains(query.toLowerCase())).toList()`
- If query is empty, `filteredCards` mirrors `allCards`

- **Estimated LOC**: ~90

---

### File 18: `lib/features/manage/widgets/card_form_sheet.dart`

- **Purpose**: Modal bottom sheet for adding or editing a flashcard. Contains two text fields with validation.
- **Dependencies**: `flashcard.dart`, `validators.dart`, `app_constants.dart`
- **Imports**: `flutter/material.dart`, `get/get.dart`, model/utils files

#### Widget Parameters

| Parameter | Type | Purpose |
|-----------|------|---------|
| `flashcard` | `Flashcard?` | `null` = Add mode, non-null = Edit mode (pre-fills) |
| `onSave` | `Function(String question, String answer)` | Callback for Add — called with new values |
| `onUpdate` | `Function(String id, String question, String answer)?` | Callback for Edit — called with id + updated values |

#### TextEditingController Lifecycle

- **Init**: Create in `initState()` — if `widget.flashcard != null`, pre-fill with `flashcard.question` and `flashcard.answer`
- **Pre-fill**: `_questionController.text = widget.flashcard!.question`
- **Dispose**: `_questionController.dispose()`, `_answerController.dispose()` in `dispose()`

#### Add vs Edit Mode Handling

- Determined by: `widget.flashcard == null` → Add mode
- Title: Add mode → `"Add Flashcard"` | Edit mode → `"Edit Flashcard"`
- Button label: Add mode → `"Save"` | Edit mode → `"Update"`
- On tap: Add mode → call `onSave(q, a)` | Edit mode → call `onUpdate!(id, q, a)`

#### Validation Trigger

- `GlobalKey<FormState> _formKey` wraps both text fields
- On Save/Update tap: `if (_formKey.currentState!.validate())` → proceed
- Each field uses `Validators.validateQuestion()` / `Validators.validateAnswer()` as its `validator`

#### Layout

- `Form` → `Column` → Question `TextFormField` (multiline, maxLength: 300, counter) → Answer `TextFormField` (multiline, maxLength: 500, counter) → `Row([Cancel, Save/Update])`

- **Estimated LOC**: ~105

---

### File 19: `lib/features/manage/widgets/card_list_item.dart`

- **Purpose**: Single list item widget displaying a flashcard's question preview with edit/delete action buttons.
- **Dependencies**: `flashcard.dart`
- **Imports**: `flutter/material.dart`, `flashcard.dart`

#### Required Parameters

| Parameter | Type | Purpose |
|-----------|------|---------|
| `flashcard` | `Flashcard` | The flashcard data to display |
| `index` | `int` | Card number for display |
| `onEdit` | `VoidCallback` | Triggered when pencil icon tapped |
| `onDelete` | `VoidCallback` | Triggered when trash icon tapped |

#### Layout

- `Card` with `ListTile`
- Leading: card number text (index + 1)
- Title: question text (single line, overflow ellipsis)
- Subtitle: answer preview (single line, overflow ellipsis)
- Trailing: `Row(mainAxisSize: min)` → `IconButton(Icons.edit)` + `IconButton(Icons.delete)`

- **Estimated LOC**: ~50

---

### File 20: `lib/features/manage/manage_screen.dart`

- **Purpose**: View for the Manage Deck screen. Displays a filterable list of all flashcards with CRUD actions.
- **Dependencies**: `manage_controller.dart`, `card_list_item.dart`, `card_form_sheet.dart`, `flashcard.dart`
- **Imports**: `flutter/material.dart`, `get/get.dart`, all related files

#### Search Field Setup

- `TextField` at top of screen body (not in AppBar)
- `decoration`: search icon prefix, "Search flashcards..." hint, clear button suffix
- `onChanged: controller.searchCards` — wires directly to controller method
- No separate `TextEditingController` needed — controller tracks query reactively

#### ListView.builder Setup

```
Obx(() => controller.filteredCards.isEmpty
  ? EmptyStateWidget
  : ListView.builder(
      itemCount: controller.filteredCards.length,
      itemBuilder: (context, index) => Dismissible(
        key: Key(controller.filteredCards[index].id),
        child: CardListItem(
          flashcard: controller.filteredCards[index],
          index: index,
          onEdit: () => _showEditSheet(controller.filteredCards[index]),
          onDelete: () => _showDeleteConfirmation(controller.filteredCards[index].id),
        ),
      ),
    )
)
```

#### Dismissible Swipe-to-Delete Configuration

- `direction: DismissDirection.endToStart` (right-to-left swipe only)
- `background`: red container with trash icon aligned right
- `confirmDismiss`: shows confirmation dialog — returns `true`/`false`
- `onDismissed`: calls `controller.deleteCard(card.id)`

#### FAB Behavior

- `FloatingActionButton` with `Icons.add` icon
- `onPressed`: opens `CardFormSheet` via `showModalBottomSheet()` in **Add mode** (no flashcard passed)
- On save callback: `controller.addCard(question, answer)` then `Navigator.pop(context)`

#### Widget Tree

```
GetView<ManageController>
└── Scaffold
    ├── AppBar: "Manage Deck", leading: back arrow (Get.back())
    ├── body: Column
    │   ├── Padding → SearchTextField
    │   └── Expanded → Obx(() → ListView or EmptyState)
    └── FAB: add new card
```

- **Estimated LOC**: ~110

---

## PHASE 6 — Wiring & Integration

### HomeController Initialization

1. App launches → `main.dart` runs → `GetStorage.init()` → `runApp(FlashMindApp())`
2. `GetMaterialApp` resolves initial route `'/'` → `HomeBinding.dependencies()` fires
3. `HomeBinding` registers: `StorageServiceImpl` → `FlashcardRepositoryImpl` → `HomeController`
4. `HomeController.onInit()` → calls `loadCards()` → repo reads from StorageService → cards populate list
5. UI builds: if cards empty → empty state; else → first card displays

### Cross-Controller Communication Strategy

**Problem**: When user adds/edits/deletes cards on Manage screen, Home screen must reflect changes when user navigates back.

**Solution — Approach A (Simple refresh on return):**
- When navigating to Manage from Home: `Get.toNamed(Routes.MANAGE)?.then((_) => controller.refreshCards())`
- `refreshCards()` re-reads all cards from repo, resets index to 0, resets flip state
- This is clean, simple, and avoids tight coupling between controllers

**Alternative — Approach B (GetX `ever()` listener on shared repo):** Overkill for this app. Keep it simple.

### GetStorage Init Sequence

```
main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Step 1: Flutter binding
  await GetStorage.init();                     // Step 2: Storage ready BEFORE any reads
  runApp(const FlashMindApp());               // Step 3: App tree builds, bindings fire
}
```

> [!IMPORTANT]
> `GetStorage.init()` **must** complete before `runApp()`. Otherwise, `StorageServiceImpl` will attempt reads on an uninitialized container.

### Full Navigation Flow

```
┌─────────────────────────────────────────────────────────┐
│                    APP START                             │
│  main() → GetStorage.init() → runApp(FlashMindApp)     │
└──────────────────────┬──────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│              HOME SCREEN (Route: '/')                    │
│  HomeBinding fires → HomeController.onInit()             │
│  → loadCards() → display first card or empty state       │
│                                                          │
│  AppBar action: "Manage Deck" icon →                     │
│    Get.toNamed(Routes.MANAGE)                           │
└──────────────────────┬──────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│           MANAGE SCREEN (Route: '/manage')               │
│  ManageBinding fires → ManageController.onInit()         │
│  → loadCards() → display list or empty state             │
│                                                          │
│  User performs CRUD → changes persist to GetStorage      │
│                                                          │
│  AppBar back arrow → Get.back()                         │
└──────────────────────┬──────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│              HOME SCREEN (returns)                        │
│  .then() fires → controller.refreshCards()               │
│  → re-reads from repo → UI rebuilds with latest data    │
└──────────────────────────────────────────────────────────┘
```

---

## PHASE 7 — QA & Testing Plan

### 9.1 Architecture Checks

| Criteria | How to Test | Pass/Fail | Edge Cases |
|----------|-------------|-----------|------------|
| No logic code in `*_screen.dart` files | Code review: grep for conditionals, loops, data manipulation in screen files | Pass: only `Obx()`, `GetView`, layout widgets found | Ensure `onPressed` callbacks only delegate to controller methods |
| All state is RxType | Code review: check every controller variable | Pass: all use `.obs` or `Rx*` types | Verify no plain `int`, `bool`, or `List` used for UI state |
| All screens use `Obx()` | Code review: search for `Obx(` in screen files | Pass: every reactive widget wrapped | Check that non-reactive widgets aren't needlessly wrapped |
| Controllers via Bindings | Code review: no `Get.put()` in screens | Pass: only `Get.lazyPut()` in Binding classes | N/A |
| Navigation uses `Get.toNamed()`/`Get.back()` | Code review: grep for `Navigator.` — should return 0 results | Pass: zero direct Navigator calls | `Navigator.pop()` in bottom sheet is acceptable (local context) |
| Repository pattern abstracted | Code review: interface exists, controller depends on abstract type | Pass: `FlashcardRepository` interface with `FlashcardRepositoryImpl` | N/A |

### 9.2 Feature Checks

| Criteria | How to Test | Pass/Fail | Edge Cases |
|----------|-------------|-----------|------------|
| Card flip animation smooth | Tap "Show Answer" — watch animation complete in ~400ms | Pass: no jitter, no mirror text on back | Rapid double-tap: should not break animation |
| Show Answer triggers flip | Tap button — card flips to reveal answer | Pass: card shows answer side | Tap again: card flips back to question |
| Previous disabled on first card | Navigate to card 1, check Previous button | Pass: button is grayed out, not tappable | With only 1 card: both buttons disabled |
| Next disabled on last card | Navigate to last card, check Next button | Pass: button is grayed out | With only 1 card: both buttons disabled |
| Counter updates | Navigate through cards, observe counter text | Pass: "Card X of Y" updates correctly | After delete: counter adjusts (Y decreases) |
| Persistence after restart | Add cards, force-close app, reopen | Pass: cards still present | Add 50+ cards, restart — all persist |
| Edit pre-fills | Tap edit on a card, check form fields | Pass: question and answer pre-populated | Edit a card with max-length text |
| Delete confirmation | Tap delete — dialog appears | Pass: dialog shows warning text | Cancel on dialog: card not deleted |
| Search filters real-time | Type in search field — list filters as you type | Pass: only matching cards shown | Search by answer text; clear search → all cards return |
| Empty state | Delete all cards (or fresh install) | Pass: illustration + guidance text shown | Add one card → empty state disappears |

### 9.3 Code Quality Checks

| Criteria | How to Test | Pass/Fail |
|----------|-------------|-----------|
| File-level doc comments | Review every file's first lines | Pass: all 20 `.dart` files have `///` header |
| Public method doc comments | Review all public methods | Pass: all have `///` doc comments |
| Rx variable inline comments | Review controller files | Pass: all Rx vars have `//` comments |
| No file exceeds 150 lines | `wc -l` or line count on each file | Pass: all ≤150 (allow ~160 with generous comments) |
| pubspec.yaml complete | Check all 5 dependencies listed | Pass: `get`, `get_storage`, `uuid`, `google_fonts`, `flutter` |
| `flutter analyze` passes | Run command in terminal | Pass: 0 issues reported |

### Additional Edge Case Tests

1. **Empty question/answer**: Try saving with empty fields → validation error shown
2. **Max length enforcement**: Type 301 chars in question → counter shows limit, validation blocks
3. **Special characters**: Add a card with emojis, unicode, newlines → persistence works correctly
4. **Rapid navigation**: Spam Next/Previous buttons quickly → no index out of bounds
5. **Concurrent operations**: Add a card while search is active → new card appears if it matches filter
6. **Device rotation**: If not locked, verify layout doesn't break (though app likely portrait-preferred)

---

## PHASE 8 — Build & Release

### Static Analysis

```bash
flutter analyze
```
- **Expected output**: `No issues found!`
- **Action if issues**: Fix all warnings and errors before proceeding

### Test Files and Coverage

| Test File | What It Tests |
|-----------|---------------|
| `test/models/flashcard_test.dart` | Model creation, `fromJson`, `toJson`, `copyWith`, equality |
| `test/utils/validators_test.dart` | Empty input, max length exceeded, valid input returns null |
| `test/repositories/flashcard_repository_test.dart` | Add/update/delete operations with mock StorageService |
| `test/controllers/home_controller_test.dart` | `loadCards`, navigation boundaries, flip toggle, refresh |
| `test/controllers/manage_controller_test.dart` | CRUD flows, search filtering |

Run all tests:
```bash
flutter test
```

### Android Release Build

```bash
# 1. Clean previous builds
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Build release APK
flutter build apk --release

# 4. Output location:
#    build/app/outputs/flutter-apk/app-release.apk
```

### iOS Release Build (macOS Only)

**Prerequisites:**
- macOS machine with Xcode 15+
- Apple Developer Account (for signing)
- Valid provisioning profile and certificates

```bash
# 1. Install CocoaPods dependencies
cd ios && pod install && cd ..

# 2. Build iOS release
flutter build ios --release

# 3. Open in Xcode for archive & distribution
open ios/Runner.xcworkspace
# Xcode: Product → Archive → Distribute App
```

### Physical Device Testing

**Android:**
1. Enable Developer Options + USB Debugging on device
2. Connect via USB, verify with `flutter devices`
3. Run: `flutter run --release`
4. Or install APK: `adb install build/app/outputs/flutter-apk/app-release.apk`

**iOS:**
1. Connect iPhone via USB
2. Trust the computer on the device
3. Open `ios/Runner.xcworkspace` in Xcode
4. Select your device as the build target
5. Set signing team in Signing & Capabilities
6. Run: `flutter run --release`

---

## IMPLEMENTATION ORDER — MASTER FILE LIST

| # | File Path | Why This Position |
|---|-----------|-------------------|
| 1 | `pubspec.yaml` | Defines all dependencies — nothing builds without it |
| 2 | `lib/core/constants/app_constants.dart` | Leaf dependency — storage keys and limits used by almost every file |
| 3 | `lib/core/utils/validators.dart` | Depends only on `app_constants` — needed by form sheets |
| 4 | `lib/data/models/flashcard.dart` | Standalone data model — required by services, repos, and controllers |
| 5 | `lib/data/services/storage_service.dart` | Depends on `flashcard` model and `app_constants` — provides persistence layer |
| 6 | `lib/data/repositories/flashcard_repository.dart` | Depends on `storage_service` and `flashcard` — provides CRUD abstraction |
| 7 | `lib/app/theme/app_theme.dart` | Standalone theme config — required by root app widget |
| 8 | `lib/app/routes/app_routes.dart` | Route constants — required by route pages and navigation calls |
| 9 | `lib/features/home/home_controller.dart` | Depends on `flashcard_repository` — must exist before its binding |
| 10 | `lib/features/manage/manage_controller.dart` | Depends on `flashcard_repository` — must exist before its binding |
| 11 | `lib/app/bindings/home_binding.dart` | Depends on service, repo, and controller — registers DI entries |
| 12 | `lib/app/bindings/manage_binding.dart` | Depends on controller and repo — registers DI entries |
| 13 | `lib/features/home/widgets/flip_card.dart` | Standalone animated widget — needed by home screen |
| 14 | `lib/features/home/widgets/nav_buttons.dart` | Standalone widget — needed by home screen |
| 15 | `lib/features/home/home_screen.dart` | Depends on controller + both widgets — complete home feature |
| 16 | `lib/features/manage/widgets/card_list_item.dart` | Standalone widget — needed by manage screen |
| 17 | `lib/features/manage/widgets/card_form_sheet.dart` | Depends on `flashcard` model and `validators` — needed by manage screen |
| 18 | `lib/features/manage/manage_screen.dart` | Depends on controller + both widgets — complete manage feature |
| 19 | `lib/app/routes/app_pages.dart` | Depends on all screens and bindings — wires routes together |
| 20 | `lib/app/app.dart` | Depends on theme and routes — root `GetMaterialApp` |
| 21 | `lib/main.dart` | Entry point — depends on `app.dart` and `get_storage` init |

---

## Project Summary

### Total Estimated Lines of Code

| Category | Files | Est. LOC |
|----------|-------|----------|
| Core (constants, validators) | 2 | ~65 |
| Data (model, service, repo) | 3 | ~180 |
| App (theme, routes, bindings, app, main) | 6 | ~197 |
| Home feature (controller, widgets, screen) | 4 | ~325 |
| Manage feature (controller, widgets, screen) | 4 | ~355 |
| **Total** | **20 Dart files** | **~1,120 lines** |

### Top 3 Technically Challenging Parts

#### 1. 3D Card Flip Animation (`flip_card.dart`)
The Y-axis rotation with `Matrix4.rotationY()` requires careful handling of the perspective transform (`setEntry(3, 2, 0.001)`), conditional front/back face rendering based on rotation angle, and preventing mirror-image text on the back face by applying an additional π rotation. The widget must also properly sync with external state (`isFlipped` from controller) via `didUpdateWidget()` while managing its own `AnimationController` lifecycle.

#### 2. Cross-Controller State Synchronization
When a user adds, edits, or deletes cards on the Manage screen and then navigates back to the Home screen, the Home controller must reflect the latest state. This requires careful architecture: ensuring the repository reads from the single source of truth (GetStorage), properly resetting the card index to prevent out-of-bounds errors if the deck shrinks, and resetting the flip state. The `.then()` callback pattern on `Get.toNamed()` must be correctly wired.

#### 3. Reactive Search with Derived State (`manage_controller.dart`)
The search filter must maintain two parallel lists (`allCards` and `filteredCards`) that stay in sync. Every CRUD operation must re-read from storage, update `allCards`, and then reapply the current search filter to update `filteredCards`. Edge cases include: adding a card that doesn't match the active filter (it should appear if search is cleared), deleting the last card matching a filter (empty state should show), and clearing the search field (full list restores instantly).
