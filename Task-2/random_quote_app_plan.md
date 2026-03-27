# 📱 Random Quote App — Flutter Implementation Plan
> **For AI Agent: Antigravity**  
> Prepared by: Moazam / Creative District  
> Version: 1.0  

---

## 🎯 Project Overview

Build a **Random Quote App** in Flutter that displays a new inspirational quote every time the app launches or the user taps the "New Quote" button. The app must have a clean, minimal, and polished UI.

---

## 🗂️ Project Structure

```
random_quote_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── models/
│   │   └── quote_model.dart
│   ├── data/
│   │   └── quotes_data.dart
│   ├── providers/
│   │   └── quote_provider.dart
│   ├── screens/
│   │   └── home_screen.dart
│   └── widgets/
│       ├── quote_card.dart
│       └── new_quote_button.dart
├── pubspec.yaml
└── README.md
```

---

## 📦 Dependencies (`pubspec.yaml`)

```yaml
name: random_quote_app
description: A minimal random quote application
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  google_fonts: ^6.2.1
  animate_do: ^3.3.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

---

## 📋 File-by-File Implementation Instructions

---

### 1. `lib/models/quote_model.dart`

Create a simple `Quote` data model class.

```dart
class Quote {
  final String text;
  final String author;

  const Quote({
    required this.text,
    required this.author,
  });
}
```

---

### 2. `lib/data/quotes_data.dart`

Create a static list of at least **20 quotes**. Include a variety of categories: motivation, wisdom, life, creativity. Sample quotes to include:

```dart
import '../models/quote_model.dart';

class QuotesData {
  static const List<Quote> quotes = [
    Quote(
      text: "The only way to do great work is to love what you do.",
      author: "Steve Jobs",
    ),
    Quote(
      text: "In the middle of every difficulty lies opportunity.",
      author: "Albert Einstein",
    ),
    Quote(
      text: "It does not matter how slowly you go as long as you do not stop.",
      author: "Confucius",
    ),
    Quote(
      text: "Life is what happens when you're busy making other plans.",
      author: "John Lennon",
    ),
    Quote(
      text: "The future belongs to those who believe in the beauty of their dreams.",
      author: "Eleanor Roosevelt",
    ),
    Quote(
      text: "Spread love everywhere you go. Let no one ever come to you without leaving happier.",
      author: "Mother Teresa",
    ),
    Quote(
      text: "When you reach the end of your rope, tie a knot in it and hang on.",
      author: "Franklin D. Roosevelt",
    ),
    Quote(
      text: "Always remember that you are absolutely unique. Just like everyone else.",
      author: "Margaret Mead",
    ),
    Quote(
      text: "Do not go where the path may lead, go instead where there is no path and leave a trail.",
      author: "Ralph Waldo Emerson",
    ),
    Quote(
      text: "You will face many defeats in life, but never let yourself be defeated.",
      author: "Maya Angelou",
    ),
    Quote(
      text: "The greatest glory in living lies not in never falling, but in rising every time we fall.",
      author: "Nelson Mandela",
    ),
    Quote(
      text: "In the end, it's not the years in your life that count. It's the life in your years.",
      author: "Abraham Lincoln",
    ),
    Quote(
      text: "Never let the fear of striking out keep you from playing the game.",
      author: "Babe Ruth",
    ),
    Quote(
      text: "Life is either a daring adventure or nothing at all.",
      author: "Helen Keller",
    ),
    Quote(
      text: "Many of life's failures are people who did not realize how close they were to success when they gave up.",
      author: "Thomas A. Edison",
    ),
    Quote(
      text: "You have brains in your head. You have feet in your shoes. You can steer yourself any direction you choose.",
      author: "Dr. Seuss",
    ),
    Quote(
      text: "If life were predictable it would cease to be life, and be without flavor.",
      author: "Eleanor Roosevelt",
    ),
    Quote(
      text: "If you look at what you have in life, you'll always have more.",
      author: "Oprah Winfrey",
    ),
    Quote(
      text: "If you want to live a happy life, tie it to a goal, not to people or things.",
      author: "Albert Einstein",
    ),
    Quote(
      text: "Never let the fear of striking out keep you from playing the game.",
      author: "Babe Ruth",
    ),
  ];
}
```

---

### 3. `lib/providers/quote_provider.dart`

Use **Provider** for state management. This class holds the current quote and handles fetching a random one, ensuring the same quote is not shown twice in a row.

```dart
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/quote_model.dart';
import '../data/quotes_data.dart';

class QuoteProvider extends ChangeNotifier {
  Quote _currentQuote = QuotesData.quotes[0];
  int _lastIndex = 0;

  Quote get currentQuote => _currentQuote;

  void loadRandomQuote() {
    final random = Random();
    int newIndex;

    // Ensure a different quote is shown each time
    do {
      newIndex = random.nextInt(QuotesData.quotes.length);
    } while (newIndex == _lastIndex);

    _lastIndex = newIndex;
    _currentQuote = QuotesData.quotes[newIndex];
    notifyListeners();
  }
}
```

---

### 4. `lib/app.dart`

Set up the root `MaterialApp` with theme configuration. The theme must be minimal and elegant.

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/quote_provider.dart';
import 'screens/home_screen.dart';

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuoteProvider()..loadRandomQuote(),
      child: MaterialApp(
        title: 'Daily Quotes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0D0D0D),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFF5C518),
            surface: Color(0xFF1A1A1A),
            onSurface: Color(0xFFEEEEEE),
          ),
          textTheme: GoogleFonts.interTextTheme(
            ThemeData.dark().textTheme,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
```

---

### 5. `lib/main.dart`

Entry point of the app.

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const QuoteApp());
}
```

---

### 6. `lib/widgets/quote_card.dart`

The main UI card that displays the quote text and author. Must have:
- A large opening quotation mark `"` as a decorative element
- Quote text in a serif or elegant font (use `GoogleFonts.playfairDisplay`)
- Author name with a subtle divider line before it
- A soft card background (slightly lighter than scaffold)
- Rounded corners with a subtle border

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../models/quote_model.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;

  const QuoteCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Decorative opening quote mark
            Text(
              '"',
              style: GoogleFonts.playfairDisplay(
                fontSize: 80,
                height: 0.8,
                color: const Color(0xFFF5C518).withOpacity(0.9),
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            // Quote text
            Text(
              quote.text,
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                height: 1.7,
                color: const Color(0xFFEEEEEE),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 28),

            // Divider
            Container(
              width: 40,
              height: 2,
              color: const Color(0xFFF5C518).withOpacity(0.6),
            ),

            const SizedBox(height: 16),

            // Author name
            Text(
              '— ${quote.author}',
              style: GoogleFonts.inter(
                fontSize: 14,
                letterSpacing: 1.2,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 7. `lib/widgets/new_quote_button.dart`

A styled CTA button that triggers loading a new quote.

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewQuoteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NewQuoteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5C518),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF5C518).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF0D0D0D),
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              'New Quote',
              style: GoogleFonts.inter(
                color: const Color(0xFF0D0D0D),
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 8. `lib/screens/home_screen.dart`

The main screen. It must:
- Use `Consumer<QuoteProvider>` to listen to state changes
- Show the app name/logo at the top
- Center the `QuoteCard` vertically
- Place the `NewQuoteButton` at the bottom
- Show a small quote counter (e.g. `"12 / 20"`) at the bottom — this is optional but adds polish

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quote_provider.dart';
import '../widgets/quote_card.dart';
import '../widgets/new_quote_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily\nQuotes',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5C518).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFF5C518).withOpacity(0.2),
                      ),
                    ),
                    child: const Icon(
                      Icons.format_quote_rounded,
                      color: Color(0xFFF5C518),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            // ── Quote Card ────────────────────────────────────────
            Expanded(
              child: Center(
                child: Consumer<QuoteProvider>(
                  builder: (context, provider, _) {
                    return QuoteCard(
                      key: ValueKey(provider.currentQuote.text),
                      quote: provider.currentQuote,
                    );
                  },
                ),
              ),
            ),

            // ── Bottom Section ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
              child: Column(
                children: [
                  Consumer<QuoteProvider>(
                    builder: (context, provider, _) {
                      return NewQuoteButton(
                        onPressed: provider.loadRandomQuote,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tap to discover a new perspective',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.2),
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Design System Summary

| Token | Value |
|---|---|
| Background | `#0D0D0D` |
| Card Surface | `#1A1A1A` |
| Accent / CTA | `#F5C518` (golden yellow) |
| Primary Text | `#EEEEEE` |
| Muted Text | `rgba(255,255,255,0.5)` |
| Quote Font | `Playfair Display` (italic, serif) |
| UI Font | `Inter` (sans-serif) |
| Border Radius (card) | `20px` |
| Border Radius (button) | `50px` (pill) |

---

## ✅ Feature Checklist

| Feature | Status |
|---|---|
| Displays a random quote on app launch | ✅ Required |
| "New Quote" button shows a different quote | ✅ Required |
| No repeated quote back-to-back | ✅ Required |
| Quote text displayed clearly | ✅ Required |
| Author name displayed clearly | ✅ Required |
| Clean and minimal dark UI | ✅ Required |
| Smooth fade-in animation on each new quote | ✅ Required |
| Portrait-only orientation locked | ✅ Required |
| Transparent status bar | ✅ Required |
| State managed via Provider | ✅ Required |

---

## 🚀 Setup & Run Instructions

```bash
# 1. Create the Flutter project
flutter create random_quote_app
cd random_quote_app

# 2. Replace pubspec.yaml with the one above

# 3. Get dependencies
flutter pub get

# 4. Create all files as per the structure above

# 5. Run the app
flutter run
```

---

## 📝 Notes for Antigravity

- Use **`ValueKey`** on `QuoteCard` so Flutter rebuilds and re-triggers the `FadeInUp` animation every time a new quote loads.
- The `QuoteProvider` initializes with `..loadRandomQuote()` inside `ChangeNotifierProvider` so the first quote is always random, not hardcoded index 0.
- The `do-while` loop in `loadRandomQuote()` guarantees no consecutive duplicate quotes.
- Keep the `home_screen.dart` layout using a `Column` with an `Expanded` middle section — this ensures the card stays centered and the button sticks to the bottom regardless of screen size.
- Do **not** add any extra packages beyond what is listed in `pubspec.yaml`.

---

*End of Implementation Plan*
