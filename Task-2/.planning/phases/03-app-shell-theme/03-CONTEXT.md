# Phase 3: App Shell & Theme - Context

**Gathered:** 2026-03-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Establishing the visual foundation of the app: Material 3 dark theme configuration, premium typography setup (Inter & Playfair Display), and system-level locks (orientation and status bar).

</domain>

<decisions>
## Implementation Decisions

### Theme & Colors
- **D-01:** Use a manual `ColorScheme` (not `fromSeed`) to ensure strict adherence to the #0D0D0D background and #F5C518 golden accent without automatic Material 3 tone shifting.
- **D-02:** Surface color will be #1A1A1A to provide subtle depth against the pure black background.

### Typography
- **D-03:** Define a custom `TextTheme` in `ThemeData`. 
- **D-04:** Use `GoogleFonts.inter()` as the primary body and label font.
- **D-05:** Use `GoogleFonts.playfairDisplay()` specifically for display roles (app name) and quote text (italic).

### System & Orientation
- **D-06:** Implement transparent status bar with light icons globally in `main.dart` using `SystemUiOverlayStyle`.
- **D-07:** Enable a "Dual-layer Lock" for portrait orientation: `SystemChrome.setPreferredOrientations` in Flutter and `android:screenOrientation="portrait"` in `AndroidManifest.xml` to prevent any rotation during the splash screen.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Requirements
- [REQUIREMENTS.md](file:///c:/Users/Moazzam%20Samoo/Desktop/Task-2/.planning/REQUIREMENTS.md) — SHELL-01 to SHELL-06

</canonical_refs>
