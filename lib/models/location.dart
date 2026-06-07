class LocationModel {
  final String name;
  final String? country;
  final String? countryCode;
  final double latitude;
  final double longitude;
  final bool isCurrentLocation;

  LocationModel({
    required this.name,
    this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
    this.isCurrentLocation = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'country': country,
        'countryCode': countryCode,
        'latitude': latitude,
        'longitude': longitude,
        'isCurrentLocation': isCurrentLocation,
      };

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        name: json['name'],
        country: json['country'],
        countryCode: json['countryCode'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        isCurrentLocation: json['isCurrentLocation'] ?? false,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  String get flagEmoji {
    if (countryCode == null || countryCode!.length != 2) return '🌐';
    final int firstLetter = countryCode!.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode!.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}
