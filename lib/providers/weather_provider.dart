import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../core/services/weather_api.dart';

final weatherApiServiceProvider = Provider((ref) => WeatherApiService());

final currentWeatherProvider = FutureProvider.family<WeatherModel, ({double lat, double lon})>((ref, pos) async {
  final api = ref.watch(weatherApiServiceProvider);
  return api.fetchCurrentWeather(pos.lat, pos.lon);
});

final forecastProvider = FutureProvider.family<ForecastData, ({double lat, double lon})>((ref, pos) async {
  final api = ref.watch(weatherApiServiceProvider);
  return api.fetchForecast(pos.lat, pos.lon);
});
