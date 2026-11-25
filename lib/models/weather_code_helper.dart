import 'package:flutter/material.dart';

class WeatherConditionInfo {
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final Color primaryColor;

  const WeatherConditionInfo({
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.primaryColor,
  });
}

class WeatherCodeHelper {
  static WeatherConditionInfo getInfo(int code) {
    switch (code) {
      case 0:
        return const WeatherConditionInfo(
          description: 'Cerah',
          icon: Icons.wb_sunny_rounded,
          primaryColor: Color(0xFFF59E0B),
          gradientColors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        );
      case 1:
        return const WeatherConditionInfo(
          description: 'Cerah Berawan',
          icon: Icons.wb_sunny_outlined,
          primaryColor: Color(0xFF3B82F6),
          gradientColors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
        );
      case 2:
        return const WeatherConditionInfo(
          description: 'Sebagian Berawan',
          icon: Icons.cloud_queue_rounded,
          primaryColor: Color(0xFF60A5FA),
          gradientColors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
        );
      case 3:
        return const WeatherConditionInfo(
          description: 'Mendung Berawan Tebal',
          icon: Icons.cloud_rounded,
          primaryColor: Color(0xFF64748B),
          gradientColors: [Color(0xFF64748B), Color(0xFF475569)],
        );
      case 45:
      case 48:
        return const WeatherConditionInfo(
          description: 'Berkabut',
          icon: Icons.foggy,
          primaryColor: Color(0xFF94A3B8),
          gradientColors: [Color(0xFF94A3B8), Color(0xFF64748B)],
        );
      case 51:
      case 53:
      case 55:
        return const WeatherConditionInfo(
          description: 'Gerimis Ringan',
          icon: Icons.grain_rounded,
          primaryColor: Color(0xFF0284C7),
          gradientColors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
        );
      case 56:
      case 57:
        return const WeatherConditionInfo(
          description: 'Gerimis Beku',
          icon: Icons.ac_unit_rounded,
          primaryColor: Color(0xFF0EA5E9),
          gradientColors: [Color(0xFF7DD3FC), Color(0xFF0284C7)],
        );
      case 61:
        return const WeatherConditionInfo(
          description: 'Hujan Ringan',
          icon: Icons.water_drop_outlined,
          primaryColor: Color(0xFF0284C7),
          gradientColors: [Color(0xFF38BDF8), Color(0xFF0369A1)],
        );
      case 63:
        return const WeatherConditionInfo(
          description: 'Hujan Sedang',
          icon: Icons.water_drop_rounded,
          primaryColor: Color(0xFF0369A1),
          gradientColors: [Color(0xFF0284C7), Color(0xFF075985)],
        );
      case 65:
        return const WeatherConditionInfo(
          description: 'Hujan Lebat',
          icon: Icons.thunderstorm_outlined,
          primaryColor: Color(0xFF1E3A8A),
          gradientColors: [Color(0xFF0369A1), Color(0xFF1E3A8A)],
        );
      case 66:
      case 67:
        return const WeatherConditionInfo(
          description: 'Hujan Es Dingin',
          icon: Icons.ac_unit_rounded,
          primaryColor: Color(0xFF0284C7),
          gradientColors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
        );
      case 71:
      case 73:
      case 75:
      case 77:
        return const WeatherConditionInfo(
          description: 'Hujan Salju',
          icon: Icons.snowing,
          primaryColor: Color(0xFF38BDF8),
          gradientColors: [Color(0xFFBAE6FD), Color(0xFF38BDF8)],
        );
      case 80:
      case 81:
      case 82:
        return const WeatherConditionInfo(
          description: 'Hujan Deras / Showers',
          icon: Icons.shower_rounded,
          primaryColor: Color(0xFF0369A1),
          gradientColors: [Color(0xFF0284C7), Color(0xFF1E40AF)],
        );
      case 85:
      case 86:
        return const WeatherConditionInfo(
          description: 'Hujan Salju Lebat',
          icon: Icons.snowing,
          primaryColor: Color(0xFF0284C7),
          gradientColors: [Color(0xFF7DD3FC), Color(0xFF0369A1)],
        );
      case 95:
        return const WeatherConditionInfo(
          description: 'Badai Petir',
          icon: Icons.thunderstorm_rounded,
          primaryColor: Color(0xFF7C3AED),
          gradientColors: [Color(0xFF8B5CF6), Color(0xFF4C1D95)],
        );
      case 96:
      case 99:
        return const WeatherConditionInfo(
          description: 'Badai Petir Disertai Es',
          icon: Icons.flash_on_rounded,
          primaryColor: Color(0xFF5B21B6),
          gradientColors: [Color(0xFF7C3AED), Color(0xFF312E81)],
        );
      default:
        return const WeatherConditionInfo(
          description: 'Berawan',
          icon: Icons.wb_cloudy_rounded,
          primaryColor: Color(0xFF3B82F6),
          gradientColors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
        );
    }
  }
}
