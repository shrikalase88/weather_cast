class ForecastDay {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String iconCode;
  final int rainProbability;
  final String description;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.iconCode,
    required this.rainProbability,
    required this.description,
  });
}

class ForecastData {
  final List<ForecastDay> daily;

  ForecastData({required this.daily});

  factory ForecastData.fromOpenWeather(Map<String, dynamic> json) {
    final list = json['list'] as List;
    final Map<String, List<Map<String, dynamic>>> groupedByDay = {};

    // Group the 3-hour forecasts by day
    for (var entry in list) {
      final date = DateTime.fromMillisecondsSinceEpoch(entry['dt'] * 1000);
      final dayKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      groupedByDay.putIfAbsent(dayKey, () => []).add(entry);
    }

    final List<ForecastDay> dailyForecasts = [];
    
    // Calculate max/min for each day
    groupedByDay.forEach((key, dayEntries) {
      double max = -double.infinity;
      double min = double.infinity;
      String icon = '';
      String description = '';
      int prob = 0;

       for (var entry in dayEntries) {
         final tempMax = entry['main']['temp_max'].toDouble();
         final tempMin = entry['main']['temp_min'].toDouble();
         if (tempMax > max) max = tempMax;
         if (tempMin < min) min = tempMin;
         
         // Take the icon, description and probability from the middle of the day if possible
         if (entry['dt_txt'].contains('12:00:00')) {
           icon = entry['weather'][0]['icon'];
           description = entry['weather'][0]['description']?.toString().toUpperCase() ?? 'CLOUDY';
           prob = ((entry['pop'] ?? 0.0) * 100).toInt();
         }
       }

       if (icon.isEmpty) {
         icon = dayEntries.first['weather'][0]['icon'];
         description = dayEntries.first['weather'][0]['description']?.toString().toUpperCase() ?? 'CLOUDY';
       }
       
       // Ensure description is never empty
       if (description.isEmpty) {
         description = 'CLOUDY';
       }

      dailyForecasts.add(ForecastDay(
        date: DateTime.parse(key),
        maxTemp: max,
        minTemp: min,
        iconCode: icon,
        rainProbability: prob,
        description: description,
      ));
    });

    return ForecastData(daily: dailyForecasts.take(7).toList());
  }
}
