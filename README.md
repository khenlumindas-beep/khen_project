# SmartTrack: AI-Based International Travel Monitoring System for CSUCC OIGE

## Summary
SmartTrack helps the CSUCC Office of the International and Global Engagement (OIGE) monitor international travel records. The first features of this starter project are a Home screen and a Login placeholder with a working navigation baseline.

## Current stack
- Implemented now: Flutter Web / Dart (client-side UI, widgets, navigation, forms).
- Planned only (not implemented in Activity 8): REST API backend (e.g., FastAPI) and PostgreSQL for persistent storage.

## Project structure
```
lib/
├── main.dart          # Entry point
├── app.dart           # MaterialApp, theme, routes
├── screens/           # Home and Login pages
├── widgets/           # Reusable AppButton and AppTextField
├── services/          # Future REST API client (placeholder)
├── models/            # Client-side data structures
├── routes/            # Route names and navigation map
└── constants/         # App-wide constants (no secrets)
```

## Run locally
Prerequisites: Flutter SDK with web support and Google Chrome installed.

```
flutter pub get
flutter run -d chrome
```

Run the tests with:
```
flutter test
```

## First checkpoint
Date: __________ | Commit: __________
