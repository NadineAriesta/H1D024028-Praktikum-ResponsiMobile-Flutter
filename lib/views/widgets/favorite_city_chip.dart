import 'package:flutter/material.dart';
import '../../models/location_model.dart';

class FavoriteCityChips extends StatelessWidget {
  final List<LocationModel> favorites;
  final LocationModel? selectedLocation;
  final Function(LocationModel) onSelectLocation;

  const FavoriteCityChips({
    super.key,
    required this.favorites,
    required this.selectedLocation,
    required this.onSelectLocation,
  });

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kota Favorit Anda',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              '${favorites.length} tersimpan',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final loc = favorites[index];
              final isSelected = selectedLocation != null &&
                  selectedLocation!.name.toLowerCase() ==
                      loc.name.toLowerCase();

              return ActionChip(
                avatar: Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.star_rounded,
                  size: 16,
                  color: isSelected ? Colors.white : const Color(0xFFF59E0B),
                ),
                label: Text(
                  loc.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                backgroundColor: isSelected
                    ? const Color(0xFF0284C7)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF0284C7)
                        : Colors.grey.shade300,
                  ),
                ),
                onPressed: () => onSelectLocation(loc),
              );
            },
          ),
        ),
      ],
    );
  }
}
