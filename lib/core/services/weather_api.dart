import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/weather.dart';
import '../../models/forecast.dart';

class WeatherApiService {
  static String get _apiKey {
    final key = dotenv.get('OPENWEATHER_API_KEY', fallback: '');
    if (key.isEmpty) {
      throw Exception('OpenWeather API key not configured. Please add OPENWEATHER_API_KEY to .env file');
    }
    return key;
  }
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherModel> fetchCurrentWeather(double lat, double lon) async {
    try {
      // 1. Fetch Current Weather
      final weatherUrl = '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
      final weatherResponse = await http.get(Uri.parse(weatherUrl)).timeout(const Duration(seconds: 10));

      if (weatherResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);
        
        // 2. Fetch Air Pollution
        final pollutionUrl = '$_baseUrl/air_pollution?lat=$lat&lon=$lon&appid=$_apiKey';
        final pollutionResponse = await http.get(Uri.parse(pollutionUrl)).timeout(const Duration(seconds: 5));
        
        double aqi = 0.0;
        if (pollutionResponse.statusCode == 200) {
          final pollutionData = json.decode(pollutionResponse.body);
          aqi = pollutionData['list'][0]['main']['aqi'].toDouble();
        }

        // 3. Fetch Forecast to get Probability of Precipitation (POP) for the current hour
        final forecastUrl = '$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&cnt=1';
        final forecastResponse = await http.get(Uri.parse(forecastUrl)).timeout(const Duration(seconds: 5));
        
        int pop = 0;
        if (forecastResponse.statusCode == 200) {
          final forecastData = json.decode(forecastResponse.body);
          pop = ((forecastData['list'][0]['pop'] ?? 0.0) * 100).toInt();
        }

        return WeatherModel.fromOpenWeather(weatherData, aqi, pop: pop);
      } else {
        throw Exception('API Error: ${weatherResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Sync failed. Please check connection.');
    }
  }

   Future<ForecastData> fetchForecast(double lat, double lon) async {
     try {
       final forecastUrl = '$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
       final response = await http.get(Uri.parse(forecastUrl)).timeout(const Duration(seconds: 10));

       if (response.statusCode == 200) {
         try {
           final data = json.decode(response.body);
           if (data['list'] == null || (data['list'] as List).isEmpty) {
             throw Exception('No forecast data in response');
           }
           return ForecastData.fromOpenWeather(data);
         } catch (parseError) {
           throw Exception('Failed to parse forecast data: $parseError');
         }
       } else {
         throw Exception('Forecast API Error: ${response.statusCode}');
       }
     } catch (e) {
       throw Exception('Failed to load forecast. Error: $e');
     }
   }
}
