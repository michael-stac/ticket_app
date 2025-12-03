# **README.md**

````markdown
# Ticket App

A Flutter-based ticket management app for browsing events, saving wishes, and managing tickets.

## Features
- 📅 Event calendar & date selection  
- 🎫 Browse and filter tickets  
- 💾 Local wishlist storage (SharedPreferences)  
- 🔍 Search by location, artist, or reference number  
- 📱 Responsive mobile UI  

## Prerequisites

Make sure you have:

- **Flutter SDK 3.0.0+**  
  ```bash
  flutter --version
````

* **Android Studio** (for Android)
* **Xcode** (for iOS, macOS only)
* **VS Code** (optional)
* **Android/iOS device or emulator**

## Getting Started

### 1. Clone the Repo

```bash
git clone https://github.com/michael-stac/ticket_app.git
cd ticket_app
```

### 2. Install Packages

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

## Using a Device

### Android

```bash
flutter devices
flutter run
```

### iOS (macOS only)

```bash
flutter devices
flutter run
```

## Project Structure

```
lib/
├── features/
│   ├── bottom_sheet/
│   ├── service/
│   ├── ticket/
│   └── utilities/
├── models/
├── providers/
├── widgets/
├── utils/
└── main.dart
```

## Helpful Commands

| Command             | Description              |
| ------------------- | ------------------------ |
| `flutter pub get`   | Install dependencies     |
| `flutter clean`     | Clear build cache        |
| `flutter run`       | Run on a device/emulator |
| `flutter build apk` | Build Android APK        |
| `flutter test`      | Run tests                |
| `flutter doctor`    | Diagnose setup issues    |

## Troubleshooting

### Common Fixes

**Pub get errors**

```bash
flutter pub cache repair
flutter clean
flutter pub get
```

**iOS pod issues**

```bash
cd ios
pod install
cd ..
flutter run
```

Always check:

```bash
flutter doctor
```

## Dependencies

Main packages:

* `provider`
* `shared_preferences`
* `intl`

Full list in `pubspec.yaml`.

## Contributing

1. Fork repo
2. Create a feature branch
3. Commit & push
4. Open a pull request


