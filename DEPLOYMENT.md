# Deployment Guide

## Pre-Release Checklist

### Android
- [ ] Set up Google Play Developer account
- [ ] Review Android app signing certificate
- [ ] Increase version code and version number
- [ ] Test on multiple Android devices (API 21+)
- [ ] Verify all permissions are justified
- [ ] Test with API key from `.env` file
- [ ] Create release keystore and backup securely

### iOS
- [ ] Set up Apple Developer account
- [ ] Create App ID in Apple Developer Portal
- [ ] Set up provisioning profiles
- [ ] Increase build number and version
- [ ] Test on actual iOS devices (11.0+)
- [ ] Generate production certificates
- [ ] Verify location permissions messaging

## Android Release Build

### 1. Configure Signing

Create or verify signing configuration in `android/app/build.gradle.kts`:

```kotlin
signingConfigs {
    release {
        keyAlias = System.getenv("KEYSTORE_ALIAS")
        keyPassword = System.getenv("KEYSTORE_PASSWORD")
        storeFile = file(System.getenv("KEYSTORE_PATH"))
        storePassword = System.getenv("KEYSTORE_PASSWORD")
    }
}
```

### 2. Environment Variables

Set required environment variables:
```bash
export KEYSTORE_PATH=/path/to/your.keystore
export KEYSTORE_ALIAS=your_key_alias
export KEYSTORE_PASSWORD=your_password
```

### 3. Build Release APK

```bash
flutter build apk --release
```

### 4. Build Release AAB (Recommended)

```bash
flutter build appbundle --release
```

**Output**: `build/app/outputs/bundle/release/app-release.aab`

### 5. Upload to Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Navigate to Release > Production
4. Upload the AAB file
5. Review app information
6. Submit for review

## iOS Release Build

### 1. Configure Xcode Project

```bash
open ios/Runner.xcworkspace
```

Configure in Xcode:
- Set Team ID
- Update Bundle Identifier
- Set provisioning profile
- Update version and build number

### 2. Create Release Build

```bash
flutter build ios --release
```

### 3. Archive Application

```bash
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -archivePath build/Runner.xcarchive \
  archive
```

### 4. Export IPA

```bash
xcodebuild -exportArchive \
  -archivePath build/Runner.xcarchive \
  -exportOptionsPlist $(pwd)/ExportOptions.plist \
  -exportPath build/Runner.ipa
```

### 5. Upload to App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. Go to TestFlight
4. Upload build using Xcode or Transporter
5. Submit for review

## Environment Configuration

### For Production

Create `.env.production`:

```env
OPENWEATHER_API_KEY=your_production_api_key
```

Ensure `.env` is loaded at startup in `main.dart`.

### API Key Recommendations

- Use production API key with appropriate rate limits
- Monitor API usage regularly
- Set up alerts for quota exceeding
- Consider API key rotation strategy

## Post-Build Testing

### Manual Testing

1. **Location Services**
   - Test with location enabled
   - Test with location disabled
   - Test with permission denied

2. **Network Conditions**
   - Test with WiFi
   - Test with cellular data
   - Test with poor connection
   - Test offline handling

3. **Data Accuracy**
   - Verify real-time weather data
   - Compare with OpenWeatherMap API directly
   - Test forecast accuracy
   - Verify air quality index

4. **User Interface**
   - Test on various screen sizes
   - Test dark mode
   - Test animations
   - Verify text readability

## Release Notes Template

```
## Version 1.0.0

### New Features
- Real-time weather display
- Multiple location support
- 5-day weather forecast
- Air quality index

### Bug Fixes
- Fixed location permission handling
- Improved network error messages

### Improvements
- Enhanced UI animations
- Better memory management
- Optimized forecast loading

### Known Issues
- None at this time

### Minimum Requirements
- iOS 11.0+
- Android 5.0+
- Internet connection required
- Location Services recommended
```

## Store Submission Guidelines

### Google Play Store

**App Content:**
- Content Rating: Complete Content Rating Questionnaire
- Target Audience: Everyone users above 3 years old
- Sensitive permissions: Justify location access

**Store Listing:**
- App Title: Weather Cast
- Short Description: (80 characters max)
- Full Description: Comprehensive feature list
- Screenshots: 5-7 high-quality images
- Feature Graphic: 1024x500 PNG

**Privacy & Security:**
- Link to Privacy Policy
- Link to Terms of Service
- Declare data practices

### App Store

**App Information:**
- App Name: Weather Cast
- Subtitle: Real-time weather at a glance
- Primary Category: Weather
- Keywords: weather, forecast, location

**App Preview:**
- 3-5 preview videos (max 30 seconds each)
- High-quality screenshots

**Compliance:**
- Privacy Policy required
- Age Rating: 4+
- Export Compliance: Not applicable
- Advertising Identifier: Not used

## Monitoring Post-Release

### Analytics
- Track crash reports
- Monitor user retention
- Review app ratings
- Analyze feature usage

### User Support
- Monitor user reviews
- Respond to feedback
- Fix reported bugs
- Implement feature requests

### Performance
- Monitor API response times
- Track location accuracy
- Review memory usage
- Monitor crash rates

## Update Process

### For Minor Updates (Bug Fixes)
1. Increment patch version (1.0.1)
2. Follow same build process
3. Expedited review available

### For Major Updates (New Features)
1. Increment minor version (1.1.0)
2. Schedule release date
3. Prepare comprehensive marketing materials

## Troubleshooting

### Build Failures
- Clean build: `flutter clean`
- Get dependencies: `flutter pub get`
- Check Flutter version: `flutter --version`

### Submission Rejection
- Review store guidelines
- Check privacy policy
- Verify permissions usage
- Test on store-approved devices

### Performance Issues
- Profile with DevTools
- Review API call frequency
- Optimize UI rendering
- Check memory leaks

---

**Last Updated**: June 2026

