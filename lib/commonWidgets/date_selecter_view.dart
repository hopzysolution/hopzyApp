import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ridebooking/utils/app_sizes.dart';
import 'package:ridebooking/globels.dart' as globals;

class DateSelectorView extends StatefulWidget {
  final Function(DateTime)? onDateChanged;
  const DateSelectorView({super.key, this.onDateChanged});

  @override
  State<DateSelectorView> createState() => _DateSelectorViewState();
}

class _DateSelectorViewState extends State<DateSelectorView> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateFormat('yyyy-MM-dd').parse(globals.selectedDate);
  }

  @override
  void didUpdateWidget(DateSelectorView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the selected date if globals.selectedDate has changed
    final globalDate = DateFormat('yyyy-MM-dd').parse(globals.selectedDate);
    if (_selectedDate != globalDate) {
      setState(() {
        _selectedDate = globalDate;
      });
    }
  }

  void _changeDate(int days) {
    final newDate = _selectedDate.add(Duration(days: days));

    // Prevent selecting date before today
    if (newDate.isBefore(DateTime.now().subtract(const Duration(
        hours: 23, minutes: 59, seconds: 59)))) {
      return; // ignore if going back before today
    }

    setState(() {
      _selectedDate = newDate;
    });
    
    // Update global state
    globals.selectedDate = DateFormat('yyyy-MM-dd').format(newDate);
    
    // Notify parent
    widget.onDateChanged?.call(newDate);
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), // prevent choosing past dates
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      
      // Update global state
      globals.selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      
      // Notify parent
      widget.onDateChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String dayMonth =
        DateFormat("d MMM").format(_selectedDate); // e.g. "6 Aug"
    final String weekday =
        DateFormat("EEE").format(_selectedDate); // e.g. "Wed"

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Backward arrow
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _changeDate(-1),
        ),

        // Date + Weekday column (clickable)
        GestureDetector(
          onTap: _pickDate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                dayMonth,
                style: TextStyle(
                  fontSize: AppSizes.md,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                weekday,
                style: TextStyle(
                  fontSize: AppSizes.md,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // Forward arrow
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _changeDate(1),
        ),
      ],
    );
  }
}