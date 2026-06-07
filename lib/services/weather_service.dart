import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class WeatherService {
  // Using NASA POWER Daily Point API
  static const String _nasaBaseUrl = 'https://power.larc.nasa.gov/api/temporal/daily/point';

  Future<WeatherData> fetchWeather(double lat, double long) async {
    // NASA POWER data has a latency (usually 2-3 days).
    // We request the last 14 days to ensure we find the most recent validated data points.
    final now = DateTime.now();
    final endDate = now; // Request up to today, parsing will handle the -999 lag
    final startDate = now.subtract(const Duration(days: 14));

    final formatter = DateFormat('yyyyMMdd');
    final startStr = formatter.format(startDate);
    final endStr = formatter.format(endDate);

    // Using 'AG' (Agroclimatology) community for better terrestrial parameter availability
    final url = '$_nasaBaseUrl?parameters=T2M,T2M_MAX,T2M_MIN,RH2M,PRECTOTCORR,WS2M&community=AG&longitude=$long&latitude=$lat&start=$startStr&end=$endStr&format=JSON';

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        String cityName = 'Unknown Location';
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
          if (placemarks.isNotEmpty) {
            final pm = placemarks.first;
            cityName = pm.locality ?? pm.subAdministrativeArea ?? pm.name ?? pm.administrativeArea ?? 'NASA Grid Point';
          }
        } catch (e) {
          cityName = 'NASA Grid Point';
        }
        
        return WeatherData.fromNasaJson(json.decode(response.body) as Map<String, dynamic>, cityName);
      } else {
        throw Exception('NASA API returned error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error. Check your internet connection.');
      }
      rethrow;
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Please enable Location Services');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // Try to get high accuracy position to ensure it doesn't default to a cached emulator position
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    ).catchError((e) {
      // Fallback to low accuracy if high fails
      return Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      );
    });
  }

  Future<WeatherData> fetchWeatherByCity(String cityName) async {
    try {
      List<Location> locations = await locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        return fetchWeather(locations.first.latitude, locations.first.longitude);
      }
      throw Exception('City not found');
    } catch (e) {
      throw Exception('Could not find NASA data for $cityName');
    }
  }
}
