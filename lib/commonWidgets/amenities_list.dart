import 'package:flutter/material.dart';

class AmenitiesList extends StatelessWidget {
  final List<String> amenities;

   AmenitiesList({super.key, required this.amenities});

  
final Map<String, IconData> amenityIcons = {
  "blanket": Icons.bed,
  "CCTV camera": Icons.videocam,
  "emergency exit": Icons.exit_to_app,
  "GPS tracking": Icons.gps_fixed,
  "hammer": Icons.construction,
  "mobile charger": Icons.battery_charging_full,
  "pillow": Icons.hotel,
  "reading light": Icons.lightbulb,
  "snacks": Icons.fastfood,
  "water bottle": Icons.local_drink,
  "wi-fi": Icons.wifi,
};

  @override
  Widget build(BuildContext context) {
    return Wrap( // 👈 Wrap allows auto line-break
      spacing: 12,
      runSpacing: 8,
      children: amenities.map((amenity) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              amenityIcons[amenity] ?? Icons.check_circle, // fallback icon
              size: 18,
              color: Colors.blueAccent,
            ),
            const SizedBox(width: 6),
            Text(
              amenity,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }
}
