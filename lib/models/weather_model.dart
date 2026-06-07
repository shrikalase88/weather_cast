class WeatherData {
  final double temperature;
  final double tempMax;
  final double tempMin;
  final double humidity;
  final double windSpeed;
  final double precipitation;
  final String cityName;
  final List<DailyRecord> history;
  final String seasonInfo;

  WeatherData({
    required this.temperature,
    required this.tempMax,
    required this.tempMin,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.cityName,
    required this.history,
    required this.seasonInfo,
  });

  factory WeatherData.fromNasaJson(Map<String, dynamic> json, String cityName) {
    final parameters = json['properties']['parameter'];
    final t2mMap = parameters['T2M'] as Map<String, dynamic>;
    
    // NASA uses -999.0 as a fill value for missing data.
    // We need to find the latest date that actually has valid data.
    String? validDate;
    final sortedDates = t2mMap.keys.toList()..sort((a, b) => b.compareTo(a));
    
    for (var date in sortedDates) {
      if (t2mMap[date] != -999 && t2mMap[date] != null) {
        validDate = date;
        break;
      }
    }

    if (validDate == null) {
      throw Exception('No valid NASA weather data found for this location.');
    }

    List<DailyRecord> historyList = [];
    t2mMap.forEach((dateStr, temp) {
      // Only add valid historical records
      if (temp != -999 && parameters['T2M_MAX'][dateStr] != -999) {
        historyList.add(DailyRecord(
          date: _parseNasaDate(dateStr),
          temp: temp.toDouble(),
          tempMax: parameters['T2M_MAX'][dateStr].toDouble(),
          tempMin: parameters['T2M_MIN'][dateStr].toDouble(),
          precipitation: parameters['PRECTOTCORR'][dateStr].toDouble(),
        ));
      }
    });

    historyList.sort((a, b) => b.date.compareTo(a.date));

    final currentTemp = t2mMap[validDate].toDouble();

    return WeatherData(
      temperature: currentTemp,
      tempMax: parameters['T2M_MAX'][validDate].toDouble(),
      tempMin: parameters['T2M_MIN'][validDate].toDouble(),
      humidity: parameters['RH2M'][validDate].toDouble(),
      windSpeed: parameters['WS2M'][validDate].toDouble(),
      precipitation: parameters['PRECTOTCORR'][validDate].toDouble(),
      cityName: cityName,
      history: historyList,
      seasonInfo: _calculateSeason(currentTemp),
    );
  }

  static DateTime _parseNasaDate(String dateStr) {
    return DateTime.parse(
      '${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}',
    );
  }

  static String _calculateSeason(double temp) {
    if (temp > 30) return "Peak Summer Season";
    if (temp > 25) return "Warm Summer Days";
    if (temp > 15) return "Pleasant Spring/Autumn";
    return "Cool Winter Vibes";
  }
}

class DailyRecord {
  final DateTime date;
  final double temp;
  final double tempMax;
  final double tempMin;
  final double precipitation;

  DailyRecord({
    required this.date,
    required this.temp,
    required this.tempMax,
    required this.tempMin,
    required this.precipitation,
  });
}
