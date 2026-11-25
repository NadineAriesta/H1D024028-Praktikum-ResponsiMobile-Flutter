import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

enum SearchState { idle, searching, success, empty, error }

class SearchViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  SearchViewModel({
    ApiService? apiService,
    LocalStorageService? localStorageService,
  })  : _apiService = apiService ?? ApiService(),
        _localStorageService = localStorageService ?? LocalStorageService();

  SearchState _state = SearchState.idle;
  SearchState get state => _state;

  bool get isSearching => _state == SearchState.searching;
  bool get isEmpty => _state == SearchState.empty;
  bool get hasError => _state == SearchState.error;
  bool get hasResults => _state == SearchState.success && _searchResults.isNotEmpty;

  List<LocationModel> _searchResults = [];
  List<LocationModel> get searchResults => _searchResults;

  List<LocationModel> _favorites = [];
  List<LocationModel> get favorites => _favorites;

  List<LocationModel> _history = [];
  List<LocationModel> get history => _history;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _currentQuery = '';
  String get currentQuery => _currentQuery;

  /// Memuat data favorit dan riwayat pencarian dari SharedPreferences
  Future<void> loadLocalData() async {
    _favorites = await _localStorageService.getFavorites();
    _history = await _localStorageService.getSearchHistory();
    notifyListeners();
  }

  /// Melakukan pencarian kota ke Open-Meteo Geocoding API
  Future<void> search(String query) async {
    _currentQuery = query.trim();

    if (_currentQuery.isEmpty) {
      _searchResults = [];
      _state = SearchState.idle;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _state = SearchState.searching;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _apiService.searchLocations(_currentQuery);
      if (results.isEmpty) {
        _state = SearchState.empty;
        _searchResults = [];
      } else {
        // Tandai apakah lokasi sudah difavoritkan sebelumnya
        for (final loc in results) {
          loc.isFavorite = _favorites.any((fav) =>
              fav.name.toLowerCase() == loc.name.toLowerCase() &&
              (fav.latitude - loc.latitude).abs() < 0.001);
        }
        _searchResults = results;
        _state = SearchState.success;
      }
    } on ApiException catch (e) {
      _state = SearchState.error;
      _errorMessage = e.message;
    } catch (e) {
      _state = SearchState.error;
      _errorMessage = 'Terjadi kesalahan saat mencari: ${e.toString()}';
    } finally {
      notifyListeners();
    }
  }

  /// Mengosongkan query dan hasil pencarian
  void clearSearch() {
    _currentQuery = '';
    _searchResults = [];
    _state = SearchState.idle;
    _errorMessage = null;
    notifyListeners();
  }

  /// Toggle status favorit lokasi
  Future<void> toggleFavorite(LocationModel location) async {
    final isFav = await _localStorageService.toggleFavorite(location);

    // Update status di search results jika ada
    for (final loc in _searchResults) {
      if (loc.name.toLowerCase() == location.name.toLowerCase() &&
          (loc.latitude - location.latitude).abs() < 0.001) {
        loc.isFavorite = isFav;
      }
    }

    await loadLocalData();
  }

  /// Menghapus seluruh riwayat pencarian
  Future<void> clearHistory() async {
    await _localStorageService.clearSearchHistory();
    _history = [];
    notifyListeners();
  }
}
