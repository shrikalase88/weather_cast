import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// A service to detect if the widget is running on a web platform and if the
/// screen size suggests a desktop or laptop view (generally > 800 width).
class IsWebDevice extends SingleChangeNotifier<bool> {
  static const double DESKTOP_WIDTH_THRESHOLD = 800.0;

  // Default to false, will be updated upon attaching to a context
  IsWebDevice() : super(false);

  /// Determines if the current view is on web and large enough to warrant desktop layout adjustments.
  @override
  bool listenDidUpdate() {
    return true; // Always update when necessary
  }

  static bool isDesktop(BuildContext context) {
    if (!kIsWeb) return false;
    final size = MediaQuery.of(context).size;
    return size.width >= DESKTOP_WIDTH_THRESHOLD;
  }

  /// Checks if the current view is web but small (mobile).
  static bool isMobile(BuildContext context) {
    if (!kIsWeb || MediaQuery.of(context).size.width >= DESKTOP_WIDTH_THRESHOLD) return false;
    return true;
  }

  /// Determines if the widget is on web and in a size range that needs special handling (e.g., tablet/medium desktop views).
  static bool isTablet(BuildContext context) {
    if (!kIsWeb) return false;
    final size = MediaQuery.of(context).size;
    return size.width >= 600.0 && size.width < DESKTOP_WIDTH_THRESHOLD;
  }

  /// A utility to dynamically update the state based on context changes (best used in a State/Consumer).
  static void updatedState(_BuildContext context) {
    final isWeb = kIsWeb;
    final isDesktopStatus = MediaQuery.of(context).size.width >= DESKTOP_WIDTH_THRESHOLD;

    // If we are web and desktop size, set true and trigger changes.
    if (isWeb && isDesktopStatus) {
      notifyListeners();
    }
  }
}