import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/location_model.dart';
import '../../viewmodels/search_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  final Function(LocationModel)? onSelectCity;

  const SearchScreen({super.key, this.onSelectCity});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().loadLocalData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    context.read<SearchViewModel>().search(query);
  }

  void _selectLocation(LocationModel location) {
    if (widget.onSelectCity != null) {
      widget.onSelectCity!(location);
    } else {
      Navigator.pop(context, location);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchVm = context.watch<SearchViewModel>();
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A)),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          'Cari Lokasi Cuaca',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Input Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _performSearch,
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  searchVm.clearSearch();
                }
              },
              decoration: InputDecoration(
                hintText: 'Ketik nama kota (misal: Jakarta, Bandung, Tokyo)...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0284C7)),
                suffixIcon: Row(
                  mainAxisSize: SearchViewModelStateHelper.getSuffixSize(_searchController.text),
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          searchVm.clearSearch();
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF0284C7)),
                      onPressed: () => _performSearch(_searchController.text),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Konten Hasil atau Riwayat/Favorit
          Expanded(
            child: _buildContent(searchVm),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(SearchViewModel searchVm) {
    if (searchVm.isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
            ),
            SizedBox(height: 16),
            Text(
              'Mencari kota di Open-Meteo...',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ],
        ),
      );
    }

    if (searchVm.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 54, color: Colors.red.shade400),
              const SizedBox(height: 16),
              const Text(
                'Pencarian Gagal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                searchVm.errorMessage ?? 'Gagal menghubungi server.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _performSearch(_searchController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (searchVm.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off_rounded, size: 54, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Kota "${searchVm.currentQuery}" tidak ditemukan',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pastikan ejaan nama kota sudah benar.',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (searchVm.hasResults) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: searchVm.searchResults.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final loc = searchVm.searchResults[index];
          return _buildLocationTile(
            location: loc,
            isFavorite: loc.isFavorite,
            onTap: () => _selectLocation(loc),
            onToggleFavorite: () => searchVm.toggleFavorite(loc),
          );
        },
      );
    }

    // Tampilan default saat input pencarian kosong: Daftar Favorit & Riwayat
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Bagian Favorit
        if (searchVm.favorites.isNotEmpty) ...[
          const Row(
            children: [
              Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
              SizedBox(width: 8),
              Text(
                'Lokasi Favorit Tersimpan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...searchVm.favorites.map(
            (loc) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildLocationTile(
                location: loc,
                isFavorite: true,
                onTap: () => _selectLocation(loc),
                onToggleFavorite: () => searchVm.toggleFavorite(loc),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Bagian Riwayat Pencarian
        if (searchVm.history.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.history_rounded, color: Color(0xFF64748B), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Riwayat Pencarian',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => searchVm.clearHistory(),
                child: const Text(
                  'Hapus Riwayat',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...searchVm.history.map(
            (loc) {
              final isFav = searchVm.favorites.any((fav) =>
                  fav.name.toLowerCase() == loc.name.toLowerCase() &&
                  (fav.latitude - loc.latitude).abs() < 0.001);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildLocationTile(
                  location: loc,
                  isFavorite: isFav,
                  onTap: () => _selectLocation(loc),
                  onToggleFavorite: () => searchVm.toggleFavorite(loc),
                ),
              );
            },
          ),
        ],

        if (searchVm.favorites.isEmpty && searchVm.history.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                children: [
                  Icon(
                    Icons.travel_explore_rounded,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cari Kota atau Lokasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Ketik nama kota di atas untuk melihat perkiraan cuaca.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationTile({
    required LocationModel location,
    required bool isFavorite,
    required VoidCallback onTap,
    required VoidCallback onToggleFavorite,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_city_rounded,
              color: Color(0xFF0284C7),
              size: 22,
            ),
          ),
          title: Text(
            location.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF1E293B),
            ),
          ),
          subtitle: Text(
            '${location.displayName}\n(Lat: ${location.latitude.toStringAsFixed(2)}, Lon: ${location.longitude.toStringAsFixed(2)})',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.3,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFavorite ? const Color(0xFFF59E0B) : Colors.grey.shade400,
              size: 26,
            ),
            tooltip: isFavorite ? 'Hapus dari favorit' : 'Simpan ke favorit',
            onPressed: onToggleFavorite,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class SearchViewModelStateHelper {
  static MainAxisSize getSuffixSize(String text) {
    return MainAxisSize.min;
  }
}
