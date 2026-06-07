import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/location_provider.dart';
import '../providers/saved_locations_provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/skeu_card.dart';
import '../widgets/skeu_button.dart';
import '../widgets/local_clock.dart';
import '../core/theme/colors.dart';
import '../core/utils/weather_icons.dart';
import '../models/location.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocationAsync = ref.watch(locationProvider);
    final savedLocations = ref.watch(savedLocationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Cast', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SkeuButton(
              onTap: () => context.push('/search'),
              borderRadius: 50,
              child: const Icon(Icons.add, color: AppColors.accent, size: 28),
            ),
          ),
        ],
      ),
      body: currentLocationAsync.when(
        data: (currentLocation) {
          final List<LocationModel> allLocations = [];
          if (currentLocation != null) allLocations.add(currentLocation);
          allLocations.addAll(savedLocations);

          if (allLocations.isEmpty) {
            return const Center(child: Text('Please enable location or add a city'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(locationProvider);
              ref.invalidate(currentWeatherProvider);
              await ref.read(locationProvider.future);
            },
            backgroundColor: AppColors.surface,
            color: AppColors.accent,
            displacement: 20,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.92),
                    itemCount: allLocations.length,
                    itemBuilder: (context, index) {
                      final loc = allLocations[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                        child: GestureDetector(
                          onTap: () => context.push('/detail', extra: loc),
                          child: LocationCard(location: loc),
                        ),
                      );
                    },
                  ),
                ),
                const Center(
                  child: Text(
                    'PULL TO SYNC ALL LOCATIONS',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gps_off_rounded, color: Colors.orangeAccent, size: 50),
              const SizedBox(height: 20),
              Text('Location Error: $err', style: const TextStyle(color: Colors.blueGrey)),
              const SizedBox(height: 20),
              SkeuButton(onTap: () => ref.refresh(locationProvider), child: const Text('RETRY')),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationCard extends ConsumerWidget {
  final LocationModel location;

  const LocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider((lat: location.latitude, lon: location.longitude)));

    return SkeuCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(location.flagEmoji, style: const TextStyle(fontSize: 26)),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  location.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          LocalClock(latitude: location.latitude, longitude: location.longitude),
          
          if (location.isCurrentLocation)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'LIVE POSITION TRACKED',
                style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.5),
              ),
            ),
          
          Expanded(
            child: weatherAsync.when(
              data: (weather) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   // Dynamic weather icon based on weather condition
                   Container(
                     padding: const EdgeInsets.all(16),
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
                       size: 70,
                       color: WeatherIconService.getWeatherColor(weather.description),
                     ),
                   ),
                   const SizedBox(height: 8),
                  Text(
                    weather.description,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2.0, color: AppColors.accent),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${weather.temperature.round()}°',
                    style: const TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.w200,
                      color: AppColors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sync, size: 10, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        'SYNCED AT ${weather.lastSynced}',
                        style: const TextStyle(fontSize: 9, color: Colors.blue, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // Optimized metrics grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetric(
                        Icons.umbrella, 
                        weather.precipitation > 0 
                            ? '${weather.precipitation.toStringAsFixed(1)}mm' 
                            : '${weather.rainChance}%', 
                        'RAIN'
                      ),
                      _buildMetric(Icons.air, '${weather.windSpeed.toStringAsFixed(1)}m/s', 'WIND'),
                      _buildMetric(Icons.water_drop, '${weather.humidity.round()}%', 'HUMID'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMetric(Icons.speed, '${weather.surfacePressure.round()}kPa', 'PRESS'),
                      _buildMetric(Icons.leaderboard, _getAQIDesc(weather.airIndex), 'AIR IDX'),
                    ],
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
              error: (err, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sync_problem_rounded, color: Colors.orangeAccent, size: 45),
                    const SizedBox(height: 15),
                    const Text(
                      'SYNCING DATA...',
                      style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Service temporarily under load. Pull to retry.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (!location.isCurrentLocation)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SkeuButton(
                onTap: () => ref.read(savedLocationsProvider.notifier).removeLocation(location),
                color: Colors.redAccent.withValues(alpha: 0.05),
                borderRadius: 30,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                    SizedBox(width: 8),
                    Text('REMOVE LOCATION', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 10)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getAQIDesc(double aqi) {
    switch (aqi.round()) {
      case 1: return 'GOOD';
      case 2: return 'FAIR';
      case 3: return 'MODERATE';
      case 4: return 'POOR';
      case 5: return 'V POOR';
      default: return 'N/A';
    }
  }

  Widget _buildMetric(IconData icon, String value, String label) {
    return SizedBox(
      width: 75,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: AppColors.textSecondary),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.1),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
