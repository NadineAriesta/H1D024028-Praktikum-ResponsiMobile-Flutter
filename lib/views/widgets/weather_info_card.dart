import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/location_model.dart';
import '../../models/weather_model.dart';
import '../../models/weather_code_helper.dart';

class WeatherInfoCard extends StatelessWidget {
  final LocationModel location;
  final CurrentWeather current;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const WeatherInfoCard({
    super.key,
    required this.location,
    required this.current,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final weatherInfo = WeatherCodeHelper.getInfo(current.weatherCode);
    final nowFormatted =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: weatherInfo.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: weatherInfo.gradientColors.last.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Nama Kota & Tombol Favorit
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            location.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        location.displayName,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: isFavorite ? const Color(0xFFFFD54F) : Colors.white,
                  size: 28,
                ),
                tooltip: isFavorite ? 'Hapus dari favorit' : 'Simpan sebagai favorit',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Main Info: Suhu & Icon Cuaca
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${current.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weatherInfo.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Terasa seperti ${current.apparentTemperature.toStringAsFixed(1)}°C',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  weatherInfo.icon,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.25), thickness: 1),
          const SizedBox(height: 8),

          // Tanggal sekarang
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nowFormatted,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Open-Meteo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
