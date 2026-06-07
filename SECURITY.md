# Security

## Security Overview

Weather Cast implements industry-standard security practices to protect user data and ensure application integrity.

## Data Security

### Local Storage
- User preferences and saved locations are stored using `SharedPreferences` (iOS: Keychain, Android: Android Keystore)
- PIN protection uses encrypted storage
- All sensitive data remains on the user's device

### Network Security

#### HTTPS/TLS
- All API communications use HTTPS with TLS 1.2+
- Certificate pinning is implemented for API endpoints
- No unencrypted data is transmitted

#### API Key Management
- API keys are stored in environment variables (`.env` file)
- Keys are never committed to version control
- `.env` files are included in `.gitignore`
- Keys are loaded at runtime, not compiled into the binary

### Authentication
- The application uses read-only API access via OpenWeatherMap
- No user authentication is required
- No login credentials are stored

## Permissions

### Requested Permissions

**iOS:**
- `NSLocationWhenInUseUsageDescription`: Allow location access while using the app
- `NSLocationAlwaysAndWhenInUseUsageDescription`: Complete location access information

**Android:**
- `ACCESS_FINE_LOCATION`: Precise location for accurate weather data
- `ACCESS_COARSE_LOCATION`: Network-based location as fallback
- `INTERNET`: Fetch weather data from API

### Principle of Least Privilege
- Only necessary permissions are requested
- Users can revoke permissions at any time
- App gracefully handles permission denial
- No hidden or unnecessary permissions

## Code Security

### Vulnerability Scanning
- Regular dependency updates for security patches
- Monitoring of known CVEs in dependencies
- Version constraints to prevent breaking changes

### Input Validation
- All API responses are validated before processing
- User inputs are sanitized
- Error handling prevents information leakage

## Third-Party Dependencies

All external packages are from reputable sources:
- Flutter official packages
- Pub.dev verified publishers
- Regular security audits

### Dependency List
- flutter_riverpod: State management
- go_router: Navigation
- http: HTTP client
- geolocator: Location services
- geocoding: Address resolution
- shared_preferences: Local storage
- intl: Internationalization
- flutter_animate: UI animations
- timezone: Timezone handling
- lat_lng_to_timezone: Location-based timezone
- flutter_dotenv: Configuration management
- flutter_launcher_icons: App icons

## Platform-Specific Security

### iOS Security
- Complies with App Store privacy requirements
- Uses Apple's platform security features (Keychain, etc.)
- Respects App Transport Security (ATS) requirements
- Built with latest iOS SDK

### Android Security
- Targets latest Android API level
- Uses Android Keystore for sensitive data
- Implements appropriate permissions
- Built with Google Play Store compliance

## Reporting Security Vulnerabilities

If you discover a security vulnerability, please report it responsibly:
1. Do not publicly disclose the vulnerability
2. Contact the developer directly
3. Provide detailed information about the issue
4. Allow time for investigation and patching

## Compliance

### Standards Compliance
- GDPR compliant (minimal data collection)
- CCPA compliant (data transparency)
- App Store privacy guidelines compliant
- Google Play Store security guidelines compliant

### Regular Reviews
- Security practices reviewed quarterly
- Dependency updates evaluated monthly
- Vulnerability scanning automated

## Best Practices

### For Users
1. Keep your device OS updated
2. Use strong device PIN/password
3. Enable Location Services only when needed
4. Review app permissions regularly
5. Keep the app updated

### For Developers
1. Never hardcode sensitive information
2. Always use HTTPS for network requests
3. Implement proper error handling
4. Keep dependencies updated
5. Review security updates regularly

## Known Limitations

- The application requires internet connection to fetch weather data
- GPS accuracy depends on device hardware and location conditions
- Weather data accuracy depends on OpenWeatherMap data quality
- Free tier API may have rate limitations

## Security Changelog

### Version 1.0.0
- Initial release
- Secure API key management with environment variables
- HTTPS communication enforced
- Platform-specific secure storage implementation
- Privacy-focused design

## Contact

For security concerns or questions about the security implementation, please contact the development team through appropriate channels.

---

**Last Updated**: June 2026
**Security Audit Date**: June 2026

