import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../../viewmodels/search_viewmodel.dart';
import 'search_screen.dart';
import 'widgets/weather_info_card.dart';
import 'widgets/weather_detail_grid.dart';
import 'widgets/forecast_item_card.dart';
import 'widgets/favorite_city_chip.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToSearch;

  const HomeScreen({super.key, this.onNavigateToSearch});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().initialize();
      context.read<SearchViewModel>().loadLocalData();
    });
  }

  void _navigateToSearch() async {
    if (widget.onNavigateToSearch != null) {
      widget.onNavigateToSearch!();
      return;
    }

    final searchVm = context.read<SearchViewModel>();
    await searchVm.loadLocalData();

    if (!mounted) return;
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );

    if (selected != null && mounted) {
      context.read<WeatherViewModel>().setLocation(selected);
      context.read<SearchViewModel>().loadLocalData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherVm = context.watch<WeatherViewModel>();
    final searchVm = context.watch<SearchViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Cuaca Terkini',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Segarkan Cuaca',
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0284C7)),
            onPressed: weatherVm.isLoading
                ? null
                : () {
                    weatherVm.fetchWeather();
                    searchVm.loadLocalData();
                  },
          ),
          IconButton(
            tooltip: 'Cari Kota',
            icon: const Icon(Icons.search_rounded, color: Color(0xFF0F172A)),
            onPressed: _navigateToSearch,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await weatherVm.fetchWeather();
          await searchVm.loadLocalData();
        },
        color: const Color(0xFF0284C7),
        child: _buildBody(weatherVm, searchVm),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToSearch,
        backgroundColor: const Color(0xFF0284C7),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.location_searching_rounded),
        label: const Text(
          'Pilih Kota Lain',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildBody(WeatherViewModel weatherVm, SearchViewModel searchVm) {
    if (weatherVm.isLoading && weatherVm.weatherData == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
            ),
            SizedBox(height: 16),
            Text(
              'Mengambil data cuaca Open-Meteo...',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (weatherVm.hasError && weatherVm.weatherData == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 64,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gagal Memuat Cuaca',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                weatherVm.errorMessage ?? 'Terjadi kesalahan pada jaringan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => weatherVm.fetchWeather(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final weatherData = weatherVm.weatherData;
    final location = weatherVm.currentLocation;

    if (weatherData == null || location == null) {
      return const Center(
        child: Text('Tidak ada data cuaca yang dapat ditampilkan.'),
      );
    }

    // Ambil kemungkinan hujan hari ini dari ramalan harian pertama
    int? todayRainChance;
    if (weatherData.dailyForecast.isNotEmpty) {
      todayRainChance = weatherData.dailyForecast.first.precipitationProbability;
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chips Kota Favorit (Quick Selector)
          if (searchVm.favorites.isNotEmpty) ...[
            FavoriteCityChips(
              favorites: searchVm.favorites,
              selectedLocation: location,
              onSelectLocation: (selected) {
                weatherVm.setLocation(selected);
              },
            ),
            const SizedBox(height: 16),
          ],

          // Kartu Cuaca Utama
          WeatherInfoCard(
            location: location,
            current: weatherData.current,
            isFavorite: weatherVm.isFavorite,
            onToggleFavorite: () async {
              await weatherVm.toggleFavorite();
              await searchVm.loadLocalData();
            },
          ),

          const SizedBox(height: 20),

          // Grid Detail Cuaca (Kelembapan, Angin, Suhu Terasa, dsb)
          WeatherDetailGrid(
            current: weatherData.current,
            rainChance: todayRainChance,
          ),

          const SizedBox(height: 24),

          // Perkiraan Cuaca Harian
          ForecastSection(dailyList: weatherData.dailyForecast),
        ],
      ),
    );
  }
}
