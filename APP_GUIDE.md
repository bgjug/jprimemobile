# jPrime Conference Mobile App

A Flutter-based mobile application for the jPrime conference, supporting iOS, Android, and Web (PWA).

## Features

- **Multi-Hall Support**: View sessions across three different halls:
  - Hall A
  - Hall B
  - Workshops

- **Session Information**: 
  - Session title
  - Speaker name (when available)
  - Session description (when available)
  - Start and end times
  - Hall location

- **Favorites Management**: 
  - Mark sessions as favorites with a star icon
  - View all favorite sessions in a dedicated tab
  - Favorites persist across app restarts using SharedPreferences

- **Modern UI**: 
  - Dark theme with jPrime purple/black color scheme
  - Glassmorphism effects with transparency
  - Beautiful gradient design elements

## Architecture

### State Management
- **flutter_bloc/Cubit**: Used for managing sessions and favorites state
- **SessionsCubit**: Handles loading sessions from the API
- **FavoritesCubit**: Manages favorite sessions with persistence

### Data Layer
- **freezed**: For immutable data models
- **json_serializable**: For JSON serialization/deserialization
- **Session Model**: Handles session data with nullable fields for TBA talks

### Dependency Injection
- **injectable**: For dependency configuration
- **get_it**: Service locator for dependency injection

### Repositories
- **SessionsRepository**: Fetches sessions from the jPrime API
- **FavoritesRepository**: Manages favorites using SharedPreferences

### API
Base URL: `https://jprime.io`
Endpoint: `/pwa/findSessionsByHall?hallName={hallName}`

Supported hall names:
- `hall A`
- `hall B`
- `workshops`

## Project Structure

```
lib/
├── core/
│   ├── di/                      # Dependency injection setup
│   │   ├── injection.dart
│   │   ├── injection.config.dart
│   │   └── register_module.dart
│   └── theme/                   # App theme and colors
│       └── app_theme.dart
├── data/
│   ├── models/                  # Data models
│   │   ├── session.dart
│   │   ├── session.freezed.dart
│   │   └── session.g.dart
│   └── repositories/            # Data repositories
│       ├── sessions_repository.dart
│       └── favorites_repository.dart
├── presentation/
│   ├── cubits/                  # State management
│   │   ├── sessions_cubit.dart
│   │   ├── sessions_cubit.freezed.dart
│   │   ├── favorites_cubit.dart
│   │   └── favorites_cubit.freezed.dart
│   ├── screens/                 # App screens
│   │   ├── home_screen.dart
│   │   ├── hall_sessions_screen.dart
│   │   ├── session_detail_screen.dart
│   │   └── favorites_screen.dart
│   └── widgets/                 # Reusable widgets
│       └── session_card.dart
└── main.dart                    # App entry point
```

## Building and Running

### Prerequisites
- Flutter SDK (^3.9.2)
- Dart SDK

### Install Dependencies
```bash
flutter pub get
```

### Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run the App

#### Web
```bash
flutter run -d chrome
```

#### iOS
```bash
flutter run -d ios
```

#### Android
```bash
flutter run -d android
```

### Build for Production

#### Web (PWA)
```bash
flutter build web --release
```

#### iOS
```bash
flutter build ios --release
```

#### Android
```bash
flutter build apk --release
```

## Key Dependencies

- `flutter_bloc: ^8.1.3` - State management
- `get_it: ^8.0.0` - Service locator
- `injectable: ^2.4.4` - Dependency injection
- `freezed: ^2.5.7` - Code generation for models
- `json_serializable: ^6.8.0` - JSON serialization
- `http: ^1.2.2` - HTTP client
- `shared_preferences: ^2.3.2` - Local storage
- `intl: ^0.19.0` - Date formatting

## Features Implementation

### Session Loading
Sessions are loaded per hall using the jPrime API. The app handles:
- Loading states with progress indicators
- Error states with retry functionality
- Empty states with helpful messages
- Pull-to-refresh on all session lists

### Favorites
Favorites are stored locally using SharedPreferences:
- Session IDs are stored as a JSON-encoded list
- Favorites persist across app restarts
- Toggle favorites with a star icon
- View all favorites in a dedicated tab

### Responsive Design
The app uses:
- Bottom navigation for easy hall switching
- Card-based UI for session display
- Full-screen detail view for sessions
- Scrollable lists for long content

## Color Scheme

Based on jPrime branding:
- Primary Purple: `#6B46C1`
- Dark Purple: `#553C9A`
- Light Purple: `#9F7AEA`
- Almost Black: `#1A1A2E`
- Dark Gray: `#16213E`
- Accent Purple: `#B794F4`

Glass effects with alpha transparency for a modern look.

## Notes

- All content is in English
- No authentication required
- No remote storage - everything is local
- Handles TBA (To Be Announced) sessions without speaker/description
- Supports different workshop durations (longer than regular talks)
