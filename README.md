# Weather Cast

A modern, sleek weather application featuring real-time weather data, location tracking, and beautiful skeuomorphic design.

## Features

### Real-Time Weather Data
- Current temperature, humidity, wind speed, and air quality index
- Real-time metrics updated directly from OpenWeatherMap API
- Last sync timestamp for data freshness verification

### Location Management
- GPS-based location detection
- Save multiple locations for quick access
- Pin protection for saved locations
- Search and add new locations worldwide

### 5-Day Forecast
- Extended weather outlook with hourly-accurate data
- Weather condition icons for each day
- Temperature highs and lows
- Detailed weather status labels

### User Interface
- Skeuomorphic design with layered visual depth
- Dark theme optimized for night usage
- Responsive layout for all device sizes
- Smooth animations and transitions
- Local clock display for each location

### Data Security
- No user tracking or analytics collection
- Minimal permissions request
- Environment-based API key management
- Secure local storage with SharedPreferences

## Requirements

### iOS
- iOS 11.0 or later
- Location Services enabled
- Internet connection

### Android
- Android 5.0 (API level 21) or later
- Location Services enabled
- Internet connection

## Installation

1. Clone the repository
2. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
3. Add your OpenWeatherMap API key to `.env`:
   ```
   OPENWEATHER_API_KEY=your_api_key_here
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run the application:
   ```bash
   flutter run
   ```

## Build Instructions

### Android Release Build
```bash
flutter build apk --release
```

### iOS Release Build
```bash
flutter build ios --release
```

## Permissions

### iOS
- **Location (When in Use)**: Required to fetch weather for user's current location
- **Internet**: Required to fetch weather data from OpenWeatherMap API

### Android
- **Fine Location**: High-accuracy GPS location data
- **Coarse Location**: Network-based location data
- **Internet**: Required to fetch weather data from OpenWeatherMap API

## Architecture

The application follows clean architecture principles with separation of concerns:

```
lib/
├── core/
│   ├── services/        # API and business logic services
│   ├── theme/          # Design system and colors
│   └── utils/          # Helper functions and utilities
├── models/             # Data models and entities
├── providers/          # State management with Flutter Riverpod
├── screens/            # UI screens and pages
└── widgets/            # Reusable UI components
```

## State Management

The application uses **Flutter Riverpod** for state management, providing:
- Reactive data flow
- Efficient rebuilds
- Testable and composable providers
- Type-safe state management

## External Dependencies

- **flutter_riverpod**: State management and dependency injection
- **go_router**: Navigation and routing
- **http**: HTTP client for API calls
- **geolocator**: Device location services
- **geocoding**: Reverse geocoding for location names
- **shared_preferences**: Local storage
- **intl**: Internationalization and formatting
- **flutter_animate**: Animation effects
- **timezone**: Timezone handling
- **lat_lng_to_timezone**: Location-to-timezone conversion
- **flutter_dotenv**: Environment configuration
- **flutter_launcher_icons**: App icon generation

## API Integration

### OpenWeatherMap API
- **Current Weather**: Real-time temperature and conditions
- **Weather Forecast**: 5-day weather outlook
- **Air Pollution**: Air quality index data

The application uses public API endpoints from OpenWeatherMap. Free tier API keys include:
- 5-day forecast data
- Current weather updates
- Air quality information

### Data Accuracy
- All data is fetched directly from the API source
- No local calculations or estimations
- Real-time updates with pull-to-refresh functionality

## Performance Optimization

- Efficient image caching
- Optimized list rendering with separation
- Lazy loading for forecast data
- Minimal rebuild cycles with Riverpod

## Testing

Unit tests and widget tests can be run with:
```bash
flutter test
```

## Troubleshooting

### API Key Not Found
Ensure `.env` file exists in the project root with valid `OPENWEATHER_API_KEY`.

### Location Permission Denied
Grant location permission in app settings (iOS: Settings > Weather Cast > Location, Android: App Settings > Permissions).

### No Network Data
Check internet connection and ensure API key is valid and has remaining requests.

## Privacy Policy

Weather Cast collects minimal data:
- Device location (only when Location Services enabled)
- Weather data from OpenWeatherMap API
- User preferences stored locally on device

No personal data is shared with third parties. All location data is processed locally.

## Support

For issues or feature requests, contact the development team.

## License

This project is proprietary software.

## Version

Current Version: 1.0.0
Build Number: 1

---

**Compatibility**: iOS 11.0+ | Android 5.0+
