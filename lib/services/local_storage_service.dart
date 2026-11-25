import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class LocalStorageService {
  static const String _keyFavorites = 'favorite_locations';
  static const String _keyHistory = 'search_history';
  static const String _keyLastLocation = 'last_selected_location';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// Mengambil daftar lokasi favorit yang tersimpan
  Future<List<LocationModel>> getFavorites() async {
    final prefs = await _prefs;
    final List<String>? jsonList = prefs.getStringList(_keyFavorites);
    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }

    return jsonList.map((item) {
      final map = json.decode(item) as Map<String, dynamic>;
      final loc = LocationModel.fromJson(map);
      loc.isFavorite = true;
      return loc;
    }).toList();
  }

  /// Menambah atau menghapus lokasi favorit (toggle)
  Future<bool> toggleFavorite(LocationModel location) async {
    final prefs = await _prefs;
    final currentFavorites = await getFavorites();

    final existingIndex = currentFavorites.indexWhere((loc) =>
        loc.name.toLowerCase() == location.name.toLowerCase() &&
        (loc.latitude - location.latitude).abs() < 0.001);

    bool isNowFavorite;
    if (existingIndex >= 0) {
      currentFavorites.removeAt(existingIndex);
      isNowFavorite = false;
    } else {
      final locToSave = location.copyWith(isFavorite: true);
      currentFavorites.add(locToSave);
      isNowFavorite = true;
    }

    final List<String> encodedList =
        currentFavorites.map((loc) => json.encode(loc.toJson())).toList();
    await prefs.setStringList(_keyFavorites, encodedList);

    return isNowFavorite;
  }

  /// Cek apakah suatu lokasi ada di daftar favorit
  Future<bool> isLocationFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    return favorites.any((loc) =>
        loc.name.toLowerCase() == location.name.toLowerCase() &&
        (loc.latitude - location.latitude).abs() < 0.001);
  }

  /// Mengambil riwayat pencarian
  Future<List<LocationModel>> getSearchHistory() async {
    final prefs = await _prefs;
    final List<String>? jsonList = prefs.getStringList(_keyHistory);
    if (jsonList == null || jsonList.isEmpty) {
      return [];
    }

    return jsonList.map((item) {
      final map = json.decode(item) as Map<String, dynamic>;
      return LocationModel.fromJson(map);
    }).toList();
  }

  /// Menambahkan lokasi ke riwayat pencarian (maksimal 10 terakhir)
  Future<void> addSearchHistory(LocationModel location) async {
    final prefs = await _prefs;
    final history = await getSearchHistory();

    // Hapus duplikat bila sebelumnya sudah ada
    history.removeWhere((loc) =>
        loc.name.toLowerCase() == location.name.toLowerCase() &&
        (loc.latitude - location.latitude).abs() < 0.001);

    // Tambahkan ke paling depan
    history.insert(0, location);

    // Batasi maksimal 10 entri riwayat
    final limitedHistory = history.take(10).toList();

    final List<String> encodedList =
        limitedHistory.map((loc) => json.encode(loc.toJson())).toList();
    await prefs.setStringList(_keyHistory, encodedList);
  }

  /// Menghapus seluruh riwayat pencarian
  Future<void> clearSearchHistory() async {
    final prefs = await _prefs;
    await prefs.remove(_keyHistory);
  }

  /// Mengambil lokasi terakhir yang dilihat pengguna
  Future<LocationModel?> getLastSelectedLocation() async {
    final prefs = await _prefs;
    final String? jsonStr = prefs.getString(_keyLastLocation);
    if (jsonStr == null) return null;

    try {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      return LocationModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Menyimpan lokasi terakhir yang sedang dibuka
  Future<void> saveLastSelectedLocation(LocationModel location) async {
    final prefs = await _prefs;
    await prefs.setString(_keyLastLocation, json.encode(location.toJson()));
  }
}
