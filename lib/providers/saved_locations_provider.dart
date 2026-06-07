import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location.dart';
import 'pin_provider.dart';

class SavedLocationsNotifier extends StateNotifier<List<LocationModel>> {
  static const String _key = 'saved_locations';
  final SharedPreferences _prefs;

  SavedLocationsNotifier(this._prefs) : super([]) {
    _load();
  }

  void _load() {
    final data = _prefs.getStringList(_key);
    if (data != null) {
      state = data.map((item) => LocationModel.fromJson(json.decode(item))).toList();
    }
  }

  Future<void> addLocation(LocationModel location) async {
    if (state.length >= 2) return; // Max 2 added locations
    if (state.contains(location)) return;

    state = [...state, location];
    await _save();
  }

  Future<void> removeLocation(LocationModel location) async {
    state = state.where((item) => item != location).toList();
    await _save();
  }

  Future<void> _save() async {
    final data = state.map((item) => json.encode(item.toJson())).toList();
    await _prefs.setStringList(_key, data);
  }
}

final savedLocationsProvider = StateNotifierProvider<SavedLocationsNotifier, List<LocationModel>>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return SavedLocationsNotifier(prefs);
});
