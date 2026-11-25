class LocationModel {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;
  final String? countryCode;
  bool isFavorite;

  LocationModel({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
    this.countryCode,
    this.isFavorite = false,
  });

  String get displayName {
    final parts = <String>[name];
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      parts.add(admin1!);
    }
    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }
    return parts.join(', ');
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int?,
      name: json['name'] as String? ?? 'Tidak diketahui',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
      countryCode: json['country_code'] as String?,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
      'country_code': countryCode,
      'is_favorite': isFavorite,
    };
  }

  LocationModel copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
    String? country,
    String? admin1,
    String? countryCode,
    bool? isFavorite,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      admin1: admin1 ?? this.admin1,
      countryCode: countryCode ?? this.countryCode,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          name.toLowerCase() == other.name.toLowerCase() &&
          (latitude - other.latitude).abs() < 0.001 &&
          (longitude - other.longitude).abs() < 0.001;

  @override
  int get hashCode => name.toLowerCase().hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
