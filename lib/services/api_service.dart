import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/location_model.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String _forecastBaseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingBaseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil data ramalan cuaca berdasarkan koordinat latitude & longitude
  Future<WeatherForecastModel> fetchWeatherForecast({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(_forecastBaseUrl).replace(queryParameters: {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
    });

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherForecastModel.fromJson(data);
      } else {
        throw ApiException(
            'Gagal mengambil data cuaca dari server (Status: ${response.statusCode})');
      }
    } on SocketException {
      throw ApiException(
          'Tidak dapat terhubung ke internet. Periksa koneksi jaringan Anda.');
    } on http.ClientException {
      throw ApiException(
          'Koneksi terputus saat mengambil data cuaca. Silakan coba lagi.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Terjadi kesalahan tidak terduga: ${e.toString()}');
    }
  }

  /// Mencari lokasi kota berdasarkan nama menggunakan Open-Meteo Geocoding API
  Future<List<LocationModel>> searchLocations(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final uri = Uri.parse(_geocodingBaseUrl).replace(queryParameters: {
      'name': query.trim(),
      'count': '10',
      'language': 'id',
      'format': 'json',
    });

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('results') && data['results'] != null) {
          final List<dynamic> results = data['results'];
          return results.map((item) => LocationModel.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        throw ApiException(
            'Gagal melakukan pencarian lokasi (Status: ${response.statusCode})');
      }
    } on SocketException {
      throw ApiException(
          'Tidak ada koneksi internet untuk melakukan pencarian kota.');
    } on http.ClientException {
      throw ApiException('Gagal terhubung ke server pencarian.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Kesalahan pencarian: ${e.toString()}');
    }
  }
}
