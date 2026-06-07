import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';
import '../models/weather_model.dart';
import '../widgets/skeuomorphic_container.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();
  List<WeatherData> _pinnedWeather = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPinnedData();
  }

  Future<void> _loadPinnedData() async {
    setState(() {
      _isLoading = true;
    });

    final pinnedCities = await _storageService.getPinnedCities();
    List<WeatherData> weatherDataList = [];

    for (String city in pinnedCities) {
      try {
        final weather = await _weatherService.fetchWeatherByCity(city);
        weatherDataList.add(weather);
      } catch (e) {
        // Skip cities that fail to load
      }
    }

    if (mounted) {
      setState(() {
        _pinnedWeather = weatherDataList;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        title: const Text('Compare Cities'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pinnedWeather.isEmpty
              ? const Center(child: Text('No cities pinned for comparison'))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    children: _pinnedWeather.map((weather) => SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _buildCompareCard(weather),
                      ),
                    )).toList(),
                  ),
                ),
    );
  }

  Widget _buildCompareCard(WeatherData weather) {
    return SkeuomorphicContainer(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        children: [
          Text(
            weather.cityName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          const Text('NASA POWER DATA', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Text(
            '${weather.temperature.toStringAsFixed(1)}°',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const SizedBox(height: 10),
          Text(weather.seasonInfo, style: const TextStyle(fontSize: 14, color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
          const Divider(height: 40),
          _buildCompareRow('Max Temp', '${weather.tempMax.round()}°'),
          _buildCompareRow('Min Temp', '${weather.tempMin.round()}°'),
          _buildCompareRow('Precipitation', '${weather.precipitation.toStringAsFixed(1)} mm'),
          _buildCompareRow('Wind Speed', '${weather.windSpeed.toStringAsFixed(1)} m/s'),
          _buildCompareRow('Humidity', '${weather.humidity.round()}%'),
        ],
      ),
    );
  }

  Widget _buildCompareRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
