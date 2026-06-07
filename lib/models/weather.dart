class WeatherModel {
  final double temperature;
  final double tempMax;
  final double tempMin;
  final double windSpeed;
  final double humidity;
  final double precipitation;
  final int rainChance; // Added Probability of Precipitation
  final double surfacePressure;
  final double airIndex;
  final String description;
  final String iconCode;
  final DateTime recordDate;
  final String formattedRecordDate;
  final String lastSynced;

  WeatherModel({
    required this.temperature,
    required this.tempMax,
    required this.tempMin,
    required this.windSpeed,
    required this.humidity,
    required this.precipitation,
    required this.rainChance,
    required this.surfacePressure,
    required this.airIndex,
    required this.description,
    required this.iconCode,
    required this.recordDate,
    required this.formattedRecordDate,
    required this.lastSynced,
  });

  factory WeatherModel.fromOpenWeather(Map<String, dynamic> json, double aqi, {int pop = 0}) {
    final main = json['main'];
    final wind = json['wind'];
    final weather = (json['weather'] as List).first;
    
    double rain = 0.0;
    if (json['rain'] != null) {
      rain = (json['rain']['1h'] ?? json['rain']['3h'] ?? 0.0).toDouble();
    } else if (json['snow'] != null) {
      rain = (json['snow']['1h'] ?? json['snow']['3h'] ?? 0.0).toDouble();
    }
    
    final date = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    String displayDate = "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}";

    final now = DateTime.now();
    final lastSyncedTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    return WeatherModel(
      temperature: main['temp'].toDouble(),
      tempMax: main['temp_max'].toDouble(),
      tempMin: main['temp_min'].toDouble(),
      windSpeed: wind['speed'].toDouble(),
      humidity: main['humidity'].toDouble(),
      precipitation: rain,
      rainChance: pop,
      surfacePressure: main['pressure'].toDouble() / 10,
      airIndex: aqi,
      description: weather['description'].toString().toUpperCase(),
      iconCode: weather['icon'],
      recordDate: date,
      formattedRecordDate: displayDate,
      lastSynced: lastSyncedTime,
    );
  }
}
