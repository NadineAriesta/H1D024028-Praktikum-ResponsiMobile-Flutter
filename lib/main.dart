import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'services/local_storage_service.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'viewmodels/search_viewmodel.dart';
import 'views/main_navigation_wrapper.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi locale bahasa Indonesia untuk format tanggal
  await initializeDateFormatting('id_ID', null);

  final apiService = ApiService();
  final localStorageService = LocalStorageService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherViewModel(
            apiService: apiService,
            localStorageService: localStorageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchViewModel(
            apiService: apiService,
            localStorageService: localStorageService,
          ),
        ),
      ],
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherCast - Aplikasi Cuaca',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationWrapper(),
    );
  }
}
