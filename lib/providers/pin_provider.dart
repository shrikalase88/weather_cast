import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PinStatus { notSet, locked, unlocked, setupInProgress }

class PinState {
  final PinStatus status;
  final int attempts;
  final String? error;

  PinState({required this.status, this.attempts = 0, this.error});

  PinState copyWith({PinStatus? status, int? attempts, String? error}) {
    return PinState(
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      error: error ?? this.error,
    );
  }
}

class PinNotifier extends StateNotifier<PinState> {
  static const String _pinKey = 'user_pin_hash';
  final SharedPreferences _prefs;

  PinNotifier(this._prefs)
      : super(PinState(
            status: _prefs.getString(_pinKey) == null
                ? PinStatus.notSet
                : PinStatus.locked));

  Future<void> setPin(String pin) async {
    await _prefs.setString(_pinKey, pin); // In real app, hash this
    state = state.copyWith(status: PinStatus.unlocked);
  }

  Future<bool> validatePin(String pin) async {
    final savedPin = _prefs.getString(_pinKey);
    if (savedPin == pin) {
      state = state.copyWith(status: PinStatus.unlocked, attempts: 0);
      return true;
    } else {
      final newAttempts = state.attempts + 1;
      state = state.copyWith(attempts: newAttempts, error: 'Incorrect PIN');
      return false;
    }
  }

  Future<void> resetPin() async {
    await _prefs.remove(_pinKey);
    state = PinState(status: PinStatus.notSet);
  }
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final pinProvider = StateNotifierProvider<PinNotifier, PinState>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return PinNotifier(prefs);
});
