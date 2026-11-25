import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_flutter_f/services/api_service.dart';

void main() {
  test('ApiService real API integration test with Open-Meteo', () async {
    final apiService = ApiService();

    // 1. Test Geocoding API: search for 'Jakarta'
    final searchResults = await apiService.searchLocations('Jakarta');
    expect(searchResults.isNotEmpty, true);
    final firstResult = searchResults.first;
    expect(firstResult.name.toLowerCase().contains('jakarta'), true);
    expect(firstResult.latitude, isNotNull);
    expect(firstResult.longitude, isNotNull);

    // 2. Test Weather Forecast API: fetch weather for Jakarta
    final weather = await apiService.fetchWeatherForecast(
      latitude: firstResult.latitude,
      longitude: firstResult.longitude,
    );

    expect(weather.current.temperature, isNotNull);
    expect(weather.current.relativeHumidity, isNotNull);
    expect(weather.current.windSpeed, isNotNull);
    expect(weather.dailyForecast.isNotEmpty, true);
  });
}
