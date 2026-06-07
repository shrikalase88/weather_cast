import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/location.dart';

final locationProvider = FutureProvider<LocationModel?>((ref) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return null;

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return null;
  }

  if (permission == LocationPermission.deniedForever) return null;

  final position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );
  
  String cityName = "Current Location";
  String? countryCode;
  String? country;

  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      final pm = placemarks.first;
      cityName = pm.locality ?? pm.subAdministrativeArea ?? pm.name ?? "Current Location";
      countryCode = pm.isoCountryCode;
      country = pm.country;
    }
  } catch (_) {}

  return LocationModel(
    name: cityName,
    country: country,
    countryCode: countryCode,
    latitude: position.latitude,
    longitude: position.longitude,
    isCurrentLocation: true,
  );
});
