import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_flutter_f/models/location_model.dart';
import 'package:responsi_flutter_f/models/weather_model.dart';
import 'package:responsi_flutter_f/models/weather_code_helper.dart';

void main() {
  group('LocationModel Test', () {
    test('Json serialization and deserialization', () {
      final json = {
        'id': 1,
        'name': 'Purwokerto',
        'latitude': -7.4244,
        'longitude': 109.2303,
        'country': 'Indonesia',
        'admin1': 'Jawa Tengah',
        'country_code': 'ID',
        'is_favorite': true,
      };

      final location = LocationModel.fromJson(json);
      expect(location.name, 'Purwokerto');
      expect(location.latitude, -7.4244);
      expect(location.longitude, 109.2303);
      expect(location.country, 'Indonesia');
      expect(location.isFavorite, true);
      expect(location.displayName, 'Purwokerto, Jawa Tengah, Indonesia');

      final serialized = location.toJson();
      expect(serialized['name'], 'Purwokerto');
      expect(serialized['is_favorite'], true);
    });
  });

  group('WeatherForecastModel Test', () {
    test('FromJson maps all required Open-Meteo fields correctly', () {
      final sampleJson = {
        'latitude': -7.42,
        'longitude': 109.23,
        'timezone': 'Asia/Jakarta',
        'current': {
          'temperature_2m': 28.5,
          'relative_humidity_2m': 82,
          'apparent_temperature': 31.2,
          'precipitation': 0.0,
          'weather_code': 1,
          'wind_speed_10m': 12.4,
        },
        'daily': {
          'time': ['2026-11-26', '2026-11-27'],
          'weather_code': [1, 61],
          'temperature_2m_max': [32.0, 30.5],
          'temperature_2m_min': [23.5, 22.8],
          'precipitation_probability_max': [40, 85],
        }
      };

      final forecast = WeatherForecastModel.fromJson(sampleJson);

      expect(forecast.current.temperature, 28.5);
      expect(forecast.current.relativeHumidity, 82);
      expect(forecast.current.apparentTemperature, 31.2);
      expect(forecast.current.precipitation, 0.0);
      expect(forecast.current.weatherCode, 1);
      expect(forecast.current.windSpeed, 12.4);

      expect(forecast.dailyForecast.length, 2);
      expect(forecast.dailyForecast[0].maxTemperature, 32.0);
      expect(forecast.dailyForecast[0].minTemperature, 23.5);
      expect(forecast.dailyForecast[0].precipitationProbability, 40);
      expect(forecast.dailyForecast[1].precipitationProbability, 85);
    });
  });

  group('WeatherCodeHelper Test', () {
    test('Translates WMO codes to Indonesian weather descriptions', () {
      expect(WeatherCodeHelper.getInfo(0).description, 'Cerah');
      expect(WeatherCodeHelper.getInfo(1).description, 'Cerah Berawan');
      expect(WeatherCodeHelper.getInfo(61).description, 'Hujan Ringan');
      expect(WeatherCodeHelper.getInfo(95).description, 'Badai Petir');
    });
  });
}
