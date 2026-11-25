import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/weather_model.dart';
import '../../models/weather_code_helper.dart';

class ForecastSection extends StatelessWidget {
  final List<DailyForecastItem> dailyList;

  const ForecastSection({super.key, required this.dailyList});

  @override
  Widget build(BuildContext context) {
    if (dailyList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perkiraan Cuaca 7 Hari ke Depan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailyList.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade100,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final item = dailyList[index];
              final info = WeatherCodeHelper.getInfo(item.weatherCode);

              String dayLabel;
              final now = DateTime.now();
              if (item.date.year == now.year &&
                  item.date.month == now.month &&
                  item.date.day == now.day) {
                dayLabel = 'Hari Ini';
              } else if (item.date.difference(DateTime(now.year, now.month, now.day)).inDays == 1) {
                dayLabel = 'Besok';
              } else {
                dayLabel = DateFormat('EEEE, d MMM', 'id_ID').format(item.date);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Hari / Tanggal
                    SizedBox(
                      width: 110,
                      child: Text(
                        dayLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: dayLabel == 'Hari Ini'
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: dayLabel == 'Hari Ini'
                              ? const Color(0xFF0284C7)
                              : const Color(0xFF334155),
                        ),
                      ),
                    ),

                    // Icon & Peluang Hujan
                    Row(
                      children: [
                        Icon(info.icon, color: info.primaryColor, size: 22),
                        const SizedBox(width: 6),
                        if (item.precipitationProbability > 0)
                          Row(
                            children: [
                              const Icon(
                                Icons.water_drop_rounded,
                                color: Color(0xFF38BDF8),
                                size: 14,
                              ),
                              Text(
                                '${item.precipitationProbability}%',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF0284C7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        else
                          const SizedBox(width: 32),
                      ],
                    ),

                    const Spacer(),

                    // Suhu Min / Max
                    Row(
                      children: [
                        Text(
                          '${item.minTemperature.toStringAsFixed(0)}°',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade200,
                                Colors.amber.shade300,
                                Colors.orange.shade400,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${item.maxTemperature.toStringAsFixed(0)}°',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
