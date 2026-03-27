# Plan: Phase 1 — Project Scaffold

**Phase:** 1
**Wave:** 1
**Requirements addressed:** SETUP-01, SETUP-02, SETUP-03
**Autonomous:** true

## Objective
Initialize the Flutter project `random_quote_app` in a subfolder, configure dependencies, and create the directory structure.

## Tasks

### 1. Initialize Flutter Project
<task>
<action>
Run `flutter create --platforms android --project-name random_quote_app random_quote_app` in the `Task-2/` directory.
</action>
<read_first>
- c:\Users\Moazzam Samoo\Desktop\Task-2\random_quote_app_plan.md
</read_first>
<acceptance_criteria>
- Directory `random_quote_app/` exists.
- `random_quote_app/android/` exists.
- `random_quote_app/ios/` does NOT exist.
</acceptance_criteria>
</task>

### 2. Configure Dependencies
<task>
<action>
Update `random_quote_app/pubspec.yaml` with the following:
- Environment SDK: `sdk: '>=3.0.0 <4.0.0'`
- Dependencies:
  - `provider: ^6.1.2`
  - `google_fonts: ^6.2.1`
  - `animate_do: ^3.3.4`
Then run `flutter pub get` inside the `random_quote_app/` directory.
</action>
<read_first>
- c:\Users\Moazzam Samoo\Desktop\Task-2\random_quote_app/pubspec.yaml
</read_first>
<acceptance_criteria>
- `pubspec.yaml` contains correct versions for `provider`, `google_fonts`, and `animate_do`.
- `flutter pub get` exits with code 0.
</acceptance_criteria>
</task>

### 3. Setup Folder Structure
<task>
<action>
Create the following directories inside `random_quote_app/lib/`:
- `models/`
- `data/`
- `providers/`
- `screens/`
- `widgets/`
</action>
<read_first>
- c:\Users\Moazzam Samoo\Desktop\Task-2\random_quote_app/lib/
</read_first>
<acceptance_criteria>
- All 5 directories exist in `lib/`.
</acceptance_criteria>
</task>

## Verification Criteria
1. `flutter build apk --debug` passes (confirms compilation for Android).
2. `flutter analyze` passes with no errors.

## must_haves
- Flutter android-only project named `random_quote_app`
- Valid `pubspec.yaml` with required dependencies
- Correct folder structure in `lib/`
