import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tzmap;
import 'package:timezone/timezone.dart' as tz;
import '../core/theme/colors.dart';

class LocalClock extends StatefulWidget {
  final double latitude;
  final double longitude;

  const LocalClock({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<LocalClock> createState() => _LocalClockState();
}

class _LocalClockState extends State<LocalClock> {
  late Timer _timer;
  late String _timeString;
  late String _dateString;
  late tz.Location _location;

  static final _timeFormat = DateFormat('hh:mm a');
  static final _dateFormat = DateFormat('EEEE, MMM d');

  @override
  void initState() {
    super.initState();
    final timezoneName = tzmap.latLngToTimezoneString(widget.latitude, widget.longitude);
    _location = tz.getLocation(timezoneName);
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = tz.TZDateTime.now(_location);
    setState(() {
      _timeString = _timeFormat.format(now);
      _dateString = _dateFormat.format(now).toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _timeString,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: 2.0,
          ),
        ),
        Text(
          _dateString,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.accent,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
