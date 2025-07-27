import 'package:flutter/material.dart';

class SeatSelectionScreen2Static extends StatefulWidget {
  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

  // Seat status enum
  enum SeatStatus { 
    driver,
    available, 
    booked, 
    femaleOnly, 
    femaleBooked, 
    maleOnly, 
    maleBooked 
  }

class _SeatSelectionScreenState extends State<SeatSelectionScreen2Static> {
  Set<int> selectedSeats = {};
  
  // Sample seat data - you can modify this based on your bus layout
  List<List<SeatStatus?>> seatLayout = [
    [null, null, null, null, SeatStatus.driver],
    [SeatStatus.available,SeatStatus.available, null, SeatStatus.available, SeatStatus.available],
    [SeatStatus.available, SeatStatus.available,null, SeatStatus.available, SeatStatus.available],
    [SeatStatus.available, SeatStatus.available,null, SeatStatus.available, SeatStatus.booked],
    [SeatStatus.available, SeatStatus.available,null, SeatStatus.available, SeatStatus.booked],
    [SeatStatus.femaleOnly, SeatStatus.femaleOnly,null, SeatStatus.available, SeatStatus.booked],
    [SeatStatus.femaleOnly, SeatStatus.femaleOnly,null, SeatStatus.available, SeatStatus.booked],
    [SeatStatus.femaleOnly, SeatStatus.booked,null, SeatStatus.available, SeatStatus.available],
    [SeatStatus.available, SeatStatus.available,null, SeatStatus.available, SeatStatus.available],
    [SeatStatus.available, SeatStatus.available,SeatStatus.available, SeatStatus.available, SeatStatus.available],
  ];

  Color getSeatColor(SeatStatus status) {
    switch (status) {
      case SeatStatus.driver:
        return Colors.grey.shade800;
      case SeatStatus.available:
        return Colors.green;
      case SeatStatus.booked:
        return Colors.grey;
      case SeatStatus.femaleOnly:
        return Colors.pink;
      case SeatStatus.femaleBooked:
        return Colors.pink.withOpacity(0.3);
      case SeatStatus.maleOnly:
        return Colors.blue;
      case SeatStatus.maleBooked:
        return Colors.blue.withOpacity(0.3);
    }
  }

  IconData getSeatIcon(SeatStatus status) {
    switch (status) {
      case SeatStatus.femaleOnly:
      case SeatStatus.femaleBooked:
        return Icons.female;
      case SeatStatus.maleOnly:
      case SeatStatus.maleBooked:
        return Icons.male;
      case SeatStatus.driver:
        return Icons.drive_eta;
      default:
        return Icons.event_seat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Seats',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Dewas → Bhopal',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Exclusive',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '5% OFF',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Seat layout
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Seats grid
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: seatLayout.asMap().entries.map((rowEntry) {
                        int rowIndex = rowEntry.key;
                        List<SeatStatus?> row = rowEntry.value;
                        
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: row.asMap().entries.map((seatEntry) {
                              int seatIndex = seatEntry.key;
                              SeatStatus? seatStatus = seatEntry.value;
                              int globalSeatIndex = rowIndex * 5 + seatIndex;
                              
                              if (seatStatus == null) {
                                return Expanded(
                                  child: SizedBox(height: 40),
                                );
                              }
                              
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (seatStatus == SeatStatus.available ||
                                        seatStatus == SeatStatus.femaleOnly ||
                                        seatStatus == SeatStatus.maleOnly) {
                                      setState(() {
                                        if (selectedSeats.contains(globalSeatIndex)) {
                                          selectedSeats.remove(globalSeatIndex);
                                        } else {
                                          selectedSeats.add(globalSeatIndex);
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: selectedSeats.contains(globalSeatIndex)
                                          ? Colors.orange
                                          : getSeatColor(seatStatus),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: getSeatColor(seatStatus).withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          getSeatIcon(seatStatus),
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        if (seatStatus == SeatStatus.available ||
                                            seatStatus == SeatStatus.femaleOnly ||
                                            seatStatus == SeatStatus.maleOnly)
                                          Text(
                                            '₹400',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        if (seatStatus == SeatStatus.booked ||
                                            seatStatus == SeatStatus.femaleBooked ||
                                            seatStatus == SeatStatus.maleBooked)
                                          Text(
                                            'Sold',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Seat type legend
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Know your seat types',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildLegendItem('Available', Colors.green, Icons.event_seat),
                        _buildLegendItem('Already booked', Colors.grey, Icons.event_seat),
                        _buildLegendItem('Available only for female passenger', Colors.pink, Icons.female),
                        _buildLegendItem('Booked by female passenger', Colors.pink.withOpacity(0.3), Icons.female),
                        _buildLegendItem('Available for male passenger', Colors.blue, Icons.male),
                        _buildLegendItem('Booked by male passenger', Colors.blue.withOpacity(0.3), Icons.male),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bus info section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: Icon(Icons.directions_bus, size: 30),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Electric Bus',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Saving 18 kg CO2E',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NueGo (Partnered by Verma Travels)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '07:25 - 10:05 • Wed, 23 Jul',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 12),
                          SizedBox(width: 2),
                          Text(
                            '4.7',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    _buildTabItem('Highlights', true),
                    _buildTabItem('Bus route', false),
                    _buildTabItem('Boarding points', false),
                    _buildTabItem('Dropping', false),
                  ],
                ),
              ],
            ),
          ),
        
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String text, bool isActive) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.red : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.red : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}