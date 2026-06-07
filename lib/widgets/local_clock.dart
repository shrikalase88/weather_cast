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
  late String _timezoneName;

  @override
  void initState() {
    super.initState();
    _timezoneName = tzmap.latLngToTimezoneString(widget.latitude, widget.longitude);
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final location = tz.getLocation(_timezoneName);
    final now = tz.TZDateTime.now(location);
    
    final timeFormat = DateFormat('hh:mm a');
    final dateFormat = DateFormat('EEEE, MMM d');

    if (mounted) {
      setState(() {
        _timeString = timeFormat.format(now);
        _dateString = dateFormat.format(now).toUpperCase();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
