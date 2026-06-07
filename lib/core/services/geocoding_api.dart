import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/location.dart';

class GeocodingApiService {
  static const String _baseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  Future<List<LocationModel>> searchCity(String query) async {
    if (query.isEmpty) return [];
    
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'name': query,
      'count': '10',
      'language': 'en',
      'format': 'json',
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] == null) return [];
      
      return (data['results'] as List)
          .where((item) => item['name'] != null && item['latitude'] != null && item['longitude'] != null)
          .map((item) => LocationModel(
                name: item['name'] as String,
                country: item['country'] as String?,
                countryCode: item['country_code'] as String?,
                latitude: (item['latitude'] as num).toDouble(),
                longitude: (item['longitude'] as num).toDouble(),
              ))
          .toList();
    } else {
      throw Exception('Failed to search city');
    }
  }
}
