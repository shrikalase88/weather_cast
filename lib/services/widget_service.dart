import 'package:home_widget/home_widget.dart';
import '../models/weather.dart';

class WidgetService {
  static const _widgetName = 'WeatherWidget';

  static Future<void> updateWeatherWidget(WeatherModel weather, String cityName, String countryCode) async {
    await HomeWidget.saveWidgetData('city_name', cityName);
    await HomeWidget.saveWidgetData('temperature', '${weather.temperature.round()}°');
    await HomeWidget.saveWidgetData('description', weather.description);
    await HomeWidget.saveWidgetData('icon_code', _mapIconCode(weather.iconCode));
    await HomeWidget.saveWidgetData('country_code', countryCode);

    await HomeWidget.updateWidget(name: _widgetName, iOSName: _widgetName);
  }

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId('group.com.wc.weatherCast');
    await HomeWidget.registerInteractivityCallback(backgroundCallback);
  }

  static Future<void> backgroundCallback(Uri? uri) async {
    if (uri != null) {
      // Handle widget tap — opens the app
    }
  }

  static String _mapIconCode(String iconCode) {
    switch (iconCode.substring(0, 2)) {
      case '01': return 'sunny';
      case '02': return 'partly_cloudy';
      case '03': case '04': return 'cloudy';
      case '09': return 'rainy';
      case '10': return 'light_rain';
      case '11': return 'storm';
      case '13': return 'snow';
      case '50': return 'fog';
      default: return 'cloudy';
    }
  }
}
