import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Kartu Profil Pengembang (Simple & Elegant)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF0284C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 52,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nadine Ariesta',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Kartu Fitur Aplikasi (Simple & Focused)
            Container(
              width: double.infinity,
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFF0284C7),
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Fitur Aplikasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    icon: Icons.wb_sunny_rounded,
                    iconBgColor: const Color(0xFF0284C7),
                    title: 'Cuaca Terkini Real-Time',
                    description: 'Pantau suhu, kelembapan, kecepatan angin, dan kondisi cuaca saat ini secara akurat.',
                  ),
                  const SizedBox(height: 14),
                  _buildFeatureItem(
                    icon: Icons.calendar_month_rounded,
                    iconBgColor: const Color(0xFF0D9488),
                    title: 'Prakiraan Cuaca 7 Hari',
                    description: 'Lihat perkiraan cuaca dan rentang suhu harian selama sepekan ke depan.',
                  ),
                  const SizedBox(height: 14),
                  _buildFeatureItem(
                    icon: Icons.search_rounded,
                    iconBgColor: const Color(0xFF6366F1),
                    title: 'Pencarian Kota Global',
                    description: 'Cari data cuaca kota atau wilayah mana saja di seluruh dunia dengan cepat.',
                  ),
                  const SizedBox(height: 14),
                  _buildFeatureItem(
                    icon: Icons.star_rounded,
                    iconBgColor: const Color(0xFFF59E0B),
                    title: 'Daftar Kota Favorit',
                    description: 'Simpan kota favorit untuk kemudahan akses langsung tanpa perlu mencari ulang.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Footer Simple
            Text(
              'WeatherCast Indonesia • Versi 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBgColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconBgColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
