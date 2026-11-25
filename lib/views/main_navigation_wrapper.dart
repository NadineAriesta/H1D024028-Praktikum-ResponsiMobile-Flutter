import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../viewmodels/search_viewmodel.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'about_screen.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().initialize();
      context.read<SearchViewModel>().loadLocalData();
    });
  }

  void _onTabSelected(int index) {
    context.read<SearchViewModel>().loadLocalData();
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateToSearch: () => _onTabSelected(1)),
      SearchScreen(
        onSelectCity: (selected) {
          context.read<WeatherViewModel>().setLocation(selected);
          context.read<SearchViewModel>().loadLocalData();
          _onTabSelected(0);
        },
      ),
      FavoritesScreen(onNavigateToTab: _onTabSelected),
      const AboutScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        backgroundColor: Colors.white,
        elevation: 8,
        indicatorColor: const Color(0xFF0284C7).withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny_rounded, color: Color(0xFF0284C7)),
            label: 'Cuaca',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded, color: Color(0xFF0284C7)),
            label: 'Cari Kota',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border_rounded),
            selectedIcon: Icon(Icons.star_rounded, color: Color(0xFFF59E0B)),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF0284C7)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
