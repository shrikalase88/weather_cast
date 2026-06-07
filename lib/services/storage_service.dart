import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _pinKey = 'user_pin';
  static const String _isFirstTimeKey = 'is_first_time';
  static const String _recoveryAnswerKey = 'recovery_answer';
  static const String _pinnedCitiesKey = 'pinned_cities';

  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstTimeKey) ?? true;
  }

  Future<void> setNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstTimeKey, false);
  }

  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
  }

  Future<void> saveRecoveryAnswer(String answer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_recoveryAnswerKey, answer.toLowerCase().trim());
  }

  Future<bool> verifyRecoveryAnswer(String answer) async {
    final prefs = await SharedPreferences.getInstance();
    final savedAnswer = prefs.getString(_recoveryAnswerKey);
    return savedAnswer == answer.toLowerCase().trim();
  }

  Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey);
  }

  Future<bool> verifyPin(String pin) async {
    final savedPin = await getPin();
    return savedPin == pin;
  }

  Future<List<String>> getPinnedCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_pinnedCitiesKey) ?? [];
  }

  Future<void> pinCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cities = await getPinnedCities();
    if (!cities.contains(cityName) && cities.length < 3) {
      cities.add(cityName);
      await prefs.setStringList(_pinnedCitiesKey, cities);
    }
  }

  Future<void> unpinCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cities = await getPinnedCities();
    cities.remove(cityName);
    await prefs.setStringList(_pinnedCitiesKey, cities);
  }
}
