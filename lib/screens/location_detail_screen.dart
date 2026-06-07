import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../widgets/skeu_card.dart';
import '../widgets/local_clock.dart';
import '../widgets/weather_metric.dart';
import '../core/theme/colors.dart';
import '../core/utils/weather_icons.dart';
import '../core/utils/weather_helpers.dart';
import '../models/location.dart';

class LocationDetailScreen extends ConsumerWidget {
  final LocationModel location;

  const LocationDetailScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider((lat: location.latitude, lon: location.longitude)));
    final forecastAsync = ref.watch(forecastProvider((lat: location.latitude, lon: location.longitude)));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(location.flagEmoji),
            const SizedBox(width: 8),
            Text(location.name),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentWeatherProvider((lat: location.latitude, lon: location.longitude)));
          ref.invalidate(forecastProvider((lat: location.latitude, lon: location.longitude)));
          await ref.read(currentWeatherProvider((lat: location.latitude, lon: location.longitude)).future);
        },
        backgroundColor: AppColors.surface,
        color: AppColors.accent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              weatherAsync.when(
                data: (weather) => SkeuCard(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Text('REAL-TIME WEATHER METRICS', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.5)),
                      const SizedBox(height: 10),
                      LocalClock(latitude: location.latitude, longitude: location.longitude),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.base,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: WeatherIconService.getWeatherColor(weather.description).withValues(alpha: 0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          WeatherIconService.getWeatherIcon(weather.description),
                          size: 80,
                          color: WeatherIconService.getWeatherColor(weather.description),
                        ),
                      ),
                      Text(
                        '${weather.temperature.round()}°',
                        style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w200, color: AppColors.textPrimary),
                      ),
                      Text(
                        weather.description,
                        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                      ),
                      const SizedBox(height: 30),
                      const Divider(color: AppColors.shadowLight),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WeatherMetric(
                            icon: Icons.umbrella,
                            value: weather.precipitation > 0
                                ? '${weather.precipitation.toStringAsFixed(1)}mm'
                                : '${weather.rainChance}%',
                            label: 'RAIN',
                          ),
                          WeatherMetric(icon: Icons.air, value: '${weather.windSpeed.toStringAsFixed(1)}m/s', label: 'WIND'),
                          WeatherMetric(icon: Icons.water_drop, value: '${weather.humidity.round()}%', label: 'HUMID'),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherMetric(icon: Icons.speed, value: '${weather.surfacePressure.round()}kPa', label: 'PRESS'),
                          WeatherMetric(icon: Icons.leaderboard, value: getAQIDescription(weather.airIndex), label: 'AIR IDX'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.shadowLight),
                      const SizedBox(height: 20),
                      _buildMetricRow('MAX TEMPERATURE', '${weather.tempMax.round()}°'),
                      _buildMetricRow('MIN TEMPERATURE', '${weather.tempMin.round()}°'),
                      _buildMetricRow('PRECIPITATION', '${weather.precipitation.toStringAsFixed(2)} mm'),
                      _buildMetricRow('HUMIDITY', '${weather.humidity.round()}%'),
                      _buildMetricRow('WIND SPEED', '${weather.windSpeed.toStringAsFixed(1)} m/s'),
                      _buildMetricRow('AIR QUALITY INDEX', getAQIDescription(weather.airIndex)),
                    ],
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                error: (err, _) => const Center(child: Text('Data currently unavailable', style: TextStyle(color: AppColors.textSecondary))),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '5-DAY FORECAST',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: 1.5),
                ),
              ),
              const SizedBox(height: 16),
              forecastAsync.when(
                data: (forecast) {
                  if (forecast.daily.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No forecast data available',
                          style: TextStyle(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: forecast.daily.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final day = forecast.daily[index];
                      return SkeuCard(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                index == 0 ? 'TODAY' : DateFormat('MMM d').format(day.date).toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.textPrimary, fontSize: 13),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.base,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    WeatherIconService.getWeatherIcon(day.description),
                                    size: 32,
                                    color: WeatherIconService.getWeatherColor(day.description),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    getWeatherStatusLabel(day.description),
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              '${day.maxTemp.round()}°',
                              style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${day.minTemp.round()}°',
                              style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off, color: Colors.orangeAccent, size: 40),
                        const SizedBox(height: 12),
                        const Text(
                          'Forecast Unavailable',
                          style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pull to refresh and try again',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.1)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 13)),
        ],
      ),
    );
  }
}
