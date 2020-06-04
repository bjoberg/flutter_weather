import 'dart:async';

import 'package:meta/meta.dart';

import 'package:flutter_weather/repositories/weather_api_client.dart';
import 'package:flutter_weather/models/models.dart';

class WeatherRepository {
  final WeatherApiClient weatherApiClient;

  WeatherRepository({@required this.weatherApiClient})
      : assert(weatherApiClient != null);

  /// Get weather for provided [city].
  ///
  /// Fetch the weather for the provided [city] name.
  Future<Weather> getWeather(String city) async {
    // TODO: these methods throw exceptions, what do we do with them?
    final locationId = await this.weatherApiClient.getLocationId(city);
    return await this.weatherApiClient.fetchWeather(locationId);
  }
}
