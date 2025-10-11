import 'package:flutter/material.dart';
import 'package:ridebooking/models/available_trip_data.dart';

class FilterRowView extends StatefulWidget {
  List<Trips>? allTrips;
   FilterRowView({Key? key,this.allTrips}) : super(key: key);

  @override
  State<FilterRowView> createState() => _FilterRowViewState();
}

class _FilterRowViewState extends State<FilterRowView> {
  // Filter states
  bool isACSelected = false;
  bool isSleeperSelected = false;
  bool isNonACSelected = false;
  bool isTimeSelected = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildFilterChip(
              label: 'Filter',
              icon: Icons.filter_list,
              isSelected: false,
              onTap: () {
                _showFilterDialog();
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Sort',
              icon: Icons.sort,
              isSelected: false,
              onTap: () {
                _showSortDialog();
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'AC',
              isSelected: isACSelected,
              onTap: () {
                setState(() {
                  isACSelected = !isACSelected;
                });
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Sleeper',
              isSelected: isSleeperSelected,
              onTap: () {
                setState(() {
                  isSleeperSelected = !isSleeperSelected;
                });
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Non AC',
              isSelected: isNonACSelected,
              onTap: () {
                setState(() {
                  isNonACSelected = !isNonACSelected;
                });
              },
            ),
            const SizedBox(width: 8),
            _buildFilterChip(
              label: 'Time',
              icon: Icons.access_time,
              isSelected: isTimeSelected,
              onTap: () {
                setState(() {
                  isTimeSelected = !isTimeSelected;
                });
                _showTimeFilterDialog();
              },
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.shade600 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.red.shade600 : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Departure Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTimeSlot('Early Morning', '12:00 AM - 6:00 AM'),
            _buildTimeSlot('Morning', '6:00 AM - 12:00 PM'),
            _buildTimeSlot('Afternoon', '12:00 PM - 6:00 PM'),
            _buildTimeSlot('Evening', '6:00 PM - 12:00 AM'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (value) {},
            activeColor: Colors.red.shade600,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(time, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildFilterOption('Bus Type', ['AC', 'Non AC', 'Sleeper', 'Semi Sleeper']),
            const Divider(),
            _buildFilterOption('Boarding Point', ['Location 1', 'Location 2', 'Location 3']),
            const Divider(),
            _buildFilterOption('Dropping Point', ['Destination 1', 'Destination 2']),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Clear all filters
                      setState(() {
                        isACSelected = false;
                        isSleeperSelected = false;
                        isNonACSelected = false;
                        isTimeSelected = false;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                    ),
                    child: const Text('Apply', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((option) => 
            FilterChip(
              label: Text(option),
              selected: false,
              onSelected: (selected) {},
              selectedColor: Colors.red.shade100,
              checkmarkColor: Colors.red.shade600,
            ),
          ).toList(),
        ),
      ],
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSortOption('Price (Low to High)', Icons.arrow_upward),
            _buildSortOption('Price (High to Low)', Icons.arrow_downward),
            _buildSortOption('Departure Time', Icons.access_time),
            _buildSortOption('Duration', Icons.schedule),
            _buildSortOption('Ratings', Icons.star),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(title),
      trailing: Radio(
        value: false,
        groupValue: null,
        onChanged: (value) {},
        activeColor: Colors.red.shade600,
      ),
      onTap: () {},
      contentPadding: EdgeInsets.zero,
    );
  }
}

// Example usage in a main app
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'RedBus Filter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Bus Booking'),
//           backgroundColor: Colors.red.shade600,
//           foregroundColor: Colors.white,
//         ),
//         body: Column(
//           children: [
//              FilterRowView(),
//             const Divider(height: 1),
//             Expanded(
//               child: Center(
//                 child: Text(
//                   'Bus List Content Goes Here',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }