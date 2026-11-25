import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

enum WeatherViewState { initial, loading, success, error }

class WeatherViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  WeatherViewModel({
    ApiService? apiService,
    LocalStorageService? localStorageService,
  })  : _apiService = apiService ?? ApiService(),
        _localStorageService = localStorageService ?? LocalStorageService();

  WeatherViewState _state = WeatherViewState.initial;
  WeatherViewState get state => _state;

  bool get isLoading => _state == WeatherViewState.loading;
  bool get hasError => _state == WeatherViewState.error;
  bool get hasData => _state == WeatherViewState.success && _weatherData != null;

  LocationModel? _currentLocation;
  LocationModel? get currentLocation => _currentLocation;

  WeatherForecastModel? _weatherData;
  WeatherForecastModel? get weatherData => _weatherData;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  /// Default lokasi awal jika belum ada yang tersimpan (Purwokerto)
  static final LocationModel defaultLocation = LocationModel(
    name: 'Purwokerto',
    latitude: -7.4244,
    longitude: 109.2303,
    country: 'Indonesia',
    admin1: 'Jawa Tengah',
    countryCode: 'ID',
  );

  /// Inisialisasi awal saat aplikasi dibuka
  Future<void> initialize() async {
    _state = WeatherViewState.loading;
    notifyListeners();

    try {
      final savedLocation = await _localStorageService.getLastSelectedLocation();
      _currentLocation = savedLocation ?? defaultLocation;
      await _checkFavoriteStatus();
      await fetchWeather();
    } catch (e) {
      _state = WeatherViewState.error;
      _errorMessage = 'Gagal memuat data awal: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Memilih lokasi baru dari hasil pencarian atau daftar favorit
  Future<void> setLocation(LocationModel location) async {
    _currentLocation = location;
    await _localStorageService.saveLastSelectedLocation(location);
    await _localStorageService.addSearchHistory(location);
    await _checkFavoriteStatus();
    await fetchWeather();
  }

  /// Mengambil data ramalan cuaca dari Open-Meteo REST API
  Future<void> fetchWeather() async {
    if (_currentLocation == null) return;

    _state = WeatherViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _weatherData = await _apiService.fetchWeatherForecast(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
      );
      _state = WeatherViewState.success;
    } on ApiException catch (e) {
      _state = WeatherViewState.error;
      _errorMessage = e.message;
    } catch (e) {
      _state = WeatherViewState.error;
      _errorMessage = 'Terjadi kesalahan sistem: ${e.toString()}';
    } finally {
      await _checkFavoriteStatus();
      notifyListeners();
    }
  }

  /// Memeriksa status favorit lokasi saat ini
  Future<void> _checkFavoriteStatus() async {
    if (_currentLocation != null) {
      _isFavorite =
          await _localStorageService.isLocationFavorite(_currentLocation!);
    }
  }

  /// Toggle bookmark/favorit kota yang sedang aktif
  Future<void> toggleFavorite() async {
    if (_currentLocation == null) return;

    final newStatus =
        await _localStorageService.toggleFavorite(_currentLocation!);
    _isFavorite = newStatus;
    _currentLocation!.isFavorite = newStatus;
    notifyListeners();
  }
}
