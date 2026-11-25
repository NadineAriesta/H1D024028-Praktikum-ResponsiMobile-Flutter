import 'package:flutter/material.dart';
import '../../models/weather_model.dart';

class WeatherDetailGrid extends StatelessWidget {
  final CurrentWeather current;
  final int? rainChance;

  const WeatherDetailGrid({
    super.key,
    required this.current,
    this.rainChance,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Cuaca Terkini',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            _buildDetailItem(
              icon: Icons.water_drop_rounded,
              iconColor: const Color(0xFF0284C7),
              title: 'Kelembapan',
              value: '${current.relativeHumidity}%',
              subtitle: 'Kelembapan relatif',
            ),
            _buildDetailItem(
              icon: Icons.air_rounded,
              iconColor: const Color(0xFF0D9488),
              title: 'Kecepatan Angin',
              value: '${current.windSpeed.toStringAsFixed(1)} km/h',
              subtitle: 'Ketinggian 10m',
            ),
            _buildDetailItem(
              icon: Icons.umbrella_rounded,
              iconColor: const Color(0xFF6366F1),
              title: 'Peluang Hujan',
              value: rainChance != null ? '$rainChance%' : '${current.precipitation} mm',
              subtitle: rainChance != null ? 'Peluang hari ini' : 'Curah hujan',
            ),
            _buildDetailItem(
              icon: Icons.thermostat_rounded,
              iconColor: const Color(0xFFF97316),
              title: 'Suhu Terasa',
              value: '${current.apparentTemperature.toStringAsFixed(1)}°C',
              subtitle: 'Suhu dirasakan tubuh',
            ),
            _buildDetailItem(
              icon: Icons.grain_rounded,
              iconColor: const Color(0xFF3B82F6),
              title: 'Curah Hujan',
              value: '${current.precipitation.toStringAsFixed(1)} mm',
              subtitle: 'Akumulasi saat ini',
            ),
            _buildDetailItem(
              icon: Icons.tag_rounded,
              iconColor: const Color(0xFF8B5CF6),
              title: 'Kode WMO',
              value: '${current.weatherCode}',
              subtitle: 'Standar meteorologi',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
