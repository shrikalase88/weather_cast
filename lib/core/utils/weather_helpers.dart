String getAQIDescription(double aqi) {
  switch (aqi.round()) {
    case 1: return 'GOOD';
    case 2: return 'FAIR';
    case 3: return 'MODERATE';
    case 4: return 'POOR';
    case 5: return 'V POOR';
    default: return 'N/A';
  }
}

String getWeatherStatusLabel(String description) {
  final lower = description.toLowerCase();

  if (lower.contains('clear') || lower.contains('sunny')) return 'SUNNY';
  if (lower.contains('cloud')) {
    if (lower.contains('few') || lower.contains('scatter')) return 'P. CLOUDY';
    return 'CLOUDY';
  }
  if (lower.contains('rain') || lower.contains('drizzle')) {
    if (lower.contains('light') || lower.contains('slight')) return 'L. RAIN';
    if (lower.contains('heavy') || lower.contains('moderate')) return 'H. RAIN';
    return 'RAINY';
  }
  if (lower.contains('thunder') || lower.contains('storm')) return 'STORMY';
  if (lower.contains('snow')) return 'SNOWY';
  if (lower.contains('mist') || lower.contains('fog')) return 'FOGGY';
  if (lower.contains('smoke') || lower.contains('dust')) return 'HAZY';

  return 'CLOUDY';
}
