# 🎙️ Daily Quotes

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://www.android.com)
[![Provider](https://img.shields.io/badge/State-Provider-blue?style=for-the-badge)](https://pub.dev/packages/provider)

A premium, minimalist, and offline-first inspirational quote application for Android. Built with a focus on high-fidelity design, smooth animations, and a seamless user experience.

---

## 🎨 Premium Aesthetics

- **Dark Mode First:** A deep matte black (#0D0D0D) canvas for reduced eye strain and high-contrast focus.
- **Golden Accents:** Elegant #F5C518 (Gold) highlights for interactive elements and brand identity.
- **Typography:** 
  - `Playfair Display`: Used for the quotes to provide a classic, sophisticated Serif feel.
  - `Inter`: Used for the system UI to ensure modern, clean readability.
- **Glassmorphism & Shadows:** Subtle surface elevations (#1A1A1A) with golden glow shadows.

## ✨ Core Features

- **Non-Consecutive Randomizer:** A sophisticated state engine that guarantees you never see the same quote twice in a row.
- **Animated Transitions:** Smooth `FadeInUp` motions on every new quote discovery.
- **Portrait Lockdown:** System-level orientation lock to maintain a perfectly composed layout.
- **Offline-First:** All quotes are bundled locally—no internet connection required.

## 🛠️ Tech Stack & Dependencies

| Dependency | Purpose |
|------------|---------|
| `provider` | State Management & Reactive UI |
| `google_fonts` | High-end typography (Inter & Playfair Display) |
| `animate_do` | Lightweight, beautiful animations |

## 🏗️ Folder Structure

```text
lib/
├── data/       # Curated quote datasets
├── models/     # Data models (Quote)
├── providers/  # State management logic (QuoteProvider)
├── widgets/    # Reusable UI components (QuoteCard, NewQuoteButton)
└── main.dart   # App entry & Theme configuration
```

## 🚀 Getting Started

1. **Clone the Repo:**
   ```bash
   git clone https://github.com/shumailamustafa/CodeAlpha_-Random_Quote.git
   ```
2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the App:**
   ```bash
   flutter run
   ```

---

*Developed by shumailamustafa as part of the CodeAlpha Random Quote Task.*
