import 'package:flutter/material.dart';

class WeatherIconService {
  /// Maps weather descriptions to appropriate Flutter icons
  static IconData getWeatherIcon(String description) {
    final lowerDesc = description.toLowerCase();

    // Clear sky conditions
    if (lowerDesc.contains('clear') || lowerDesc.contains('sunny') || lowerDesc.contains('sky is clear')) {
      return Icons.wb_sunny_rounded;
    }

    // Cloudy conditions
    if (lowerDesc.contains('cloud')) {
      if (lowerDesc.contains('overcast')) {
        return Icons.cloud_rounded;
      }
      if (lowerDesc.contains('few') || lowerDesc.contains('scatter')) {
        return Icons.wb_sunny_rounded;
      }
      return Icons.wb_cloudy_rounded;
    }

    // Rainy conditions
    if (lowerDesc.contains('rain') || lowerDesc.contains('drizzle')) {
      if (lowerDesc.contains('light') || lowerDesc.contains('slight')) {
        return Icons.cloud_queue_rounded;
      }
      if (lowerDesc.contains('heavy') || lowerDesc.contains('moderate') || lowerDesc.contains('rain and')) {
        return Icons.water_drop_rounded;
      }
      return Icons.grain_rounded;
    }

    // Thunderstorm conditions
    if (lowerDesc.contains('thunder') || lowerDesc.contains('storm') || lowerDesc.contains('thunderstorm')) {
      return Icons.flash_on_rounded;
    }

    // Snow conditions
    if (lowerDesc.contains('snow')) {
      return Icons.ac_unit_rounded;
    }

    // Mist/Fog conditions
    if (lowerDesc.contains('mist') || lowerDesc.contains('fog') || lowerDesc.contains('haze')) {
      return Icons.cloud_off_rounded;
    }

    // Smoke/Dust
    if (lowerDesc.contains('smoke') || lowerDesc.contains('dust') || lowerDesc.contains('sand')) {
      return Icons.cloud_circle_rounded;
    }

    // Ash/Squall/Tornado
    if (lowerDesc.contains('ash') || lowerDesc.contains('squall') || lowerDesc.contains('tornado')) {
      return Icons.waves_rounded;
    }

    // Default to cloud icon
    return Icons.wb_cloudy_rounded;
  }

  /// Returns a color based on weather condition
  static Color getWeatherColor(String description) {
    final lowerDesc = description.toLowerCase();

    if (lowerDesc.contains('clear') || lowerDesc.contains('sunny')) {
      return Colors.amber;
    }

    if (lowerDesc.contains('rain') || lowerDesc.contains('drizzle')) {
      return Colors.blue;
    }

    if (lowerDesc.contains('thunder') || lowerDesc.contains('storm')) {
      return Colors.indigo;
    }

    if (lowerDesc.contains('snow')) {
      return Colors.cyan;
    }

    if (lowerDesc.contains('cloud')) {
      return Colors.blueGrey;
    }

    if (lowerDesc.contains('mist') || lowerDesc.contains('fog')) {
      return Colors.grey;
    }

    return Colors.blue;
  }

  /// Get emoji representation of weather
  static String getWeatherEmoji(String description) {
    final lowerDesc = description.toLowerCase();

    if (lowerDesc.contains('clear') || lowerDesc.contains('sunny')) return '☀️';
    if (lowerDesc.contains('cloud') && !lowerDesc.contains('rain')) return '☁️';
    if (lowerDesc.contains('rain') || lowerDesc.contains('drizzle')) return '🌧️';
    if (lowerDesc.contains('thunder') || lowerDesc.contains('storm')) return '⛈️';
    if (lowerDesc.contains('snow')) return '❄️';
    if (lowerDesc.contains('mist') || lowerDesc.contains('fog')) return '🌫️';
    if (lowerDesc.contains('wind')) return '💨';

    return '🌤️';
  }
}

