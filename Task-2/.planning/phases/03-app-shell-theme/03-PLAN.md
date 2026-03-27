# Phase 3: App Shell & Theme - Plan

**Phase Goal:** Configure the root `MaterialApp` with the premium dark theme, lock orientation, and style the system UI.

## 📋 Requirements
- [ ] **SHELL-01**: MaterialApp configured with Material 3 dark theme
- [ ] **SHELL-02**: Custom color scheme: background #0D0D0D, surface #1A1A1A, accent #F5C518
- [ ] **SHELL-03**: Google Fonts (Inter) applied as base text theme
- [ ] **SHELL-04**: Debug banner removed
- [ ] **SHELL-05**: Portrait-only orientation locked via SystemChrome & AndroidManifest
- [ ] **SHELL-06**: Transparent status bar with light icons

## 🛠️ Implementation Steps

### 1. Native Configuration
- [ ] Modify `android/app/src/main/AndroidManifest.xml` to set `android:screenOrientation="portrait"` for the main activity.

### 2. Main Entry Point (System Chrome)
- [ ] Update `lib/main.dart` to initialize `WidgetsFlutterBinding`.
- [ ] Add `SystemChrome` calls to lock orientation to `portraitUp`.
- [ ] Set `SystemUiOverlayStyle` for transparent status bar and light icons.

### 3. Theme Configuration
- [ ] In `lib/main.dart`, define a `ThemeData` object.
- [ ] Configure `ColorScheme` with deep black/gold palette.
- [ ] Integrate `GoogleFonts.interTextTheme()` as the base.
- [ ] Set `useMaterial3: true`.

### 4. Root App Update
- [ ] Apply the theme to `MaterialApp`.
- [ ] Set `debugShowCheckedModeBanner: false`.

## 🧪 Verification Plan
- [ ] **Visual:** Run the app (Android) and verify the background is #0D0D0D.
- [ ] **System:** Check that status bar icons are visible (white/light) on the dark background.
- [ ] **Behavior:** Attempt to rotate the device to landscape; verify it stays in portrait.
- [ ] **Analyze:** Run `flutter analyze` to ensure no theme-related errors.
