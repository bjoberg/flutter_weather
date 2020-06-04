import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_weather/models/models.dart';

class WeatherApiClient {
  static const baseUrl = 'https://www.metaweather.com';
  final http.Client httpClient;

  WeatherApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  /// Get location id for provided [city].
  ///
  /// Get the location id (woeid) defined by the provided [city] name. Throw an [Exception] if the
  /// search request is not successful.
  Future<int> getLocationId(String city) async {
    final locationUrl = "$baseUrl/api/location/search/?query=$city";
    final locationResponse = await this.httpClient.get(locationUrl);

    if (locationResponse.statusCode != 200) {
      throw Exception("error getting locationId for city");
    }

    final locationJson = jsonDecode(locationResponse.body) as List;
    return (locationJson.first)['woeid'];
  }

  /// Get weather for provide [locationId]
  ///
  /// Get the weather defined by the provided [locationId]. Throw and [Excpetion] if the search
  /// request is not successful.
  Future<Weather> fetchWeather(int locationId) async {
    final weatherUrl = "$baseUrl/api/location/$locationId";
    final weatherResponse = await this.httpClient.get(weatherUrl);

    if (weatherResponse.statusCode != 200) {
      throw Exception("error getting weather for location");
    }

    final weatherJson = jsonDecode(weatherResponse.body);
    return Weather.fromJson(weatherJson);
  }
}
