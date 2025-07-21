// lib/widgets/seat_legend.dart
import 'package:flutter/material.dart';

class SeatLegend extends StatelessWidget {
  const SeatLegend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seat Legend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem(
                color: const Color(0xFF4CAF50),
                label: 'Available',
                icon: Icons.event_seat,
              ),
              _buildLegendItem(
                color: const Color(0xFF9E9E9E),
                label: 'Booked',
                icon: Icons.event_seat,
              ),
              _buildLegendItem(
                color: const Color(0xFF2196F3),
                label: 'Selected',
                icon: Icons.event_seat,
              ),
              _buildLegendItem(
                color: const Color(0xFFE91E63),
                label: 'Ladies',
                icon: Icons.event_seat,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTypeItem(
                icon: Icons.star,
                label: 'Premium',
                color: Colors.amber,
              ),
              const SizedBox(width: 16),
              _buildTypeItem(
                icon: Icons.bed,
                label: 'Sleeper',
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required IconData icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 14,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
