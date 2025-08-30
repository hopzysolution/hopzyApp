
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ridebooking/models/trip_plan_data.dart';

class TripPlannerWidget extends StatefulWidget {
  final String? geminiApiKey;
  final EdgeInsetsGeometry? padding;
  final Color? primaryColor;
  final Color? backgroundColor;
  final TextStyle? headerTextStyle;
  final TextStyle? subHeaderTextStyle;
  final Function(TripPlanData)? onTripPlanGenerated;
  final Function(String)? onError;
  final bool showHeader;
  final bool showBackButton;
  final VoidCallback? onBack;

  const TripPlannerWidget({
    Key? key,
    this.geminiApiKey,
    this.padding,
    this.primaryColor,
    this.backgroundColor,
    this.headerTextStyle,
    this.subHeaderTextStyle,
    this.onTripPlanGenerated,
    this.onError,
    this.showHeader = true,
    this.showBackButton = false,
    this.onBack,
  }) : super(key: key);

  @override
  State<TripPlannerWidget> createState() => _TripPlannerWidgetState();
}

class _TripPlannerWidgetState extends State<TripPlannerWidget>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  
  String _selectedDuration = '1';
  String _selectedTravelStyle = 'Balanced';
  bool _isLoading = false;
  bool _showForm = true;
  
  TripPlanData? _tripData;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<String> _durations = ['1', '2', '3', '4', '5'];
  final List<String> _travelStyles = [
    'Balanced', 'Cultural & Historical', 'Romantic', 'Family-Friendly', 'Adventure & Outdoor'
  ];

  Color get _primaryColor => widget.primaryColor ?? const Color(0xFF0047FF);
  Color get _backgroundColor => widget.backgroundColor ?? Colors.white;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _destinationController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  Future<void> _planTrip() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    await _animationController.forward();
    
    try {
      final String geminiApiKey = widget.geminiApiKey ?? 'AIzaSyCZRLpjjzWNGpIOi6gJHJ92M6_bBHZ0z6I';
      const String geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
      
      final String prompt = '''
You are an expert AI Travel Planner. Your response MUST be a single, valid JSON object.

**CRITICAL INSTRUCTION 1: The plan MUST strictly match the Travel Style: '$_selectedTravelStyle'.**
- For 'Romantic', every suggestion must be suitable for couples. Avoid religious places unless they are famous for their beauty.
- All suggested activities, hotels, and restaurants MUST be located *inside* the city of '${_destinationController.text}'. Do not suggest places in other cities.

**User Request:**
- Destination: ${_destinationController.text}
- Duration: $_selectedDuration days
- People: ${_peopleController.text}
- Travel Style: $_selectedTravelStyle

**JSON Output Structure Rules:**
1. **itinerary**: An array of day-by-day plans.
   - Each day object must have: "day", "title", and an "activities" array.
   - Each day MUST contain a minimum of 2 and maximum of 3 activities.
   - Each activity object MUST have:
     - "name": The name of the place.
     - "description": A detailed, engaging paragraph describing the place.
     - "why_famous": A concise bullet point list (array of strings) of what makes it famous.

2. **restaurant_recommendations**: An array of 8-10 restaurant objects.
   - Each restaurant object MUST have:
     - "name": The restaurant's name.
     - "cuisine": The type of food.
     - "food_type": Either "Veg", "Non-Veg", or "Veg/Non-Veg".
     - "rating": The restaurant's rating (e.g., "4.8/5").
     - "details": A short sentence on why it's recommended.
     - "timing": Opening and closing hours as a string.

3. **special_message**: Set to null for good matches, or a 3-line polite message for potential mismatches.
''';

      final response = await http.post(
        Uri.parse('$geminiUrl?key=$geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [{'text': prompt}]
            }
          ],
          'generationConfig': {
            'response_mime_type': 'application/json',
          }
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final tripPlanText = responseData['candidates'][0]['content']['parts'][0]['text'];
        final tripPlanJson = json.decode(tripPlanText);
        
        final tripData = TripPlanData.fromJson(tripPlanJson);
        
        setState(() {
          _tripData = tripData;
          _showForm = false;
        });

        // Call the callback if provided
        widget.onTripPlanGenerated?.call(tripData);
      } else {
        _showError('Failed to generate trip plan. Please try again.');
      }
    } catch (e) {
      _showError('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    widget.onError?.call(message);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _startNewPlan() {
    setState(() {
      _showForm = true;
      _tripData = null;
    });
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(0),
      color: _backgroundColor,
      child: _isLoading
          ? const TripPlannerLoadingWidget()
          : _showForm
              ? _buildFormScreen()
              : _buildResultScreen(),
    );
  }

  Widget _buildFormScreen() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.showBackButton && widget.onBack != null) ...[
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBack,
                      icon: Icon(
                        Icons.arrow_back,
                        color: _primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
              if (widget.showHeader) ...[
                const SizedBox(height: 40),
                Text(
                  'AI Trip Planner ✨',
                  style: widget.headerTextStyle ?? const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your personal AI guide to perfectly planned trips.',
                  style: widget.subHeaderTextStyle ?? const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF555555),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
              ],
              
              // Destination Field
              _buildTextField(
                controller: _destinationController,
                label: 'Destination',
                hint: 'e.g., Goa',
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a destination' : null,
              ),
              const SizedBox(height: 20),
              
              // Duration Dropdown
              _buildDropdown(
                label: 'Duration (in days)',
                value: _selectedDuration,
                items: _durations.map((d) => '$d Day${d == '1' ? '' : 's'}').toList(),
                values: _durations,
                onChanged: (value) => setState(() => _selectedDuration = value!),
              ),
              const SizedBox(height: 20),
              
              // Travel Style Dropdown
              _buildDropdown(
                label: 'Travel Style',
                value: _selectedTravelStyle,
                items: _travelStyles,
                values: _travelStyles,
                onChanged: (value) => setState(() => _selectedTravelStyle = value!),
              ),
              const SizedBox(height: 20),
              
              // People Field
              _buildTextField(
                controller: _peopleController,
                label: 'Number of People',
                hint: 'e.g., 2',
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter number of people' : null,
              ),
              const SizedBox(height: 30),
              
              // Generate Button
              ElevatedButton(
                onPressed: _planTrip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Generate Plan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required List<String> values,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: const Color(0xFFCCCCCC)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            items: items.map((String item) {
              int index = items.indexOf(item);
              return DropdownMenuItem<String>(
                value: values[index],
                child: Text(item),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    if (_tripData == null) return const SizedBox.shrink();
    
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTripSummary(),
          if (_tripData!.specialMessage != null) _buildSpecialMessage(),
          _buildItinerary(),
          _buildRestaurantRecommendations(),
        ],
      ),
    );
  }

  Widget _buildTripSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Your Trip Details',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _buildSummaryCard('Destination', _destinationController.text),
              _buildSummaryCard('Duration', '$_selectedDuration days'),
              _buildSummaryCard('People', _peopleController.text),
              _buildSummaryCard('Travel Style', _selectedTravelStyle),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: _startNewPlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Start New Plan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF8E3),
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: Color(0xFFF0AD4E), width: 5),
        ),
      ),
      child: Text(
        _tripData!.specialMessage!,
        style: const TextStyle(
          color: Color(0xFF8A6D3B),
          fontSize: 16,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildItinerary() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Itinerary',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          ...(_tripData?.itinerary ?? []).map(_buildDayCard).toList(),
        ],
      ),
    );
  }

  Widget _buildDayCard(DayPlan day) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day ${day.day}: ${day.title}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...day.activities.map(_buildActivityCard).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5D4),
              borderRadius: BorderRadius.circular(8),
              border: const Border(
                left: BorderSide(color: Color(0xFFFF8055), width: 4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  activity.description,
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(color: _primaryColor, width: 4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Why Famous:',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                ...activity.whyFamous.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Color(0xFF718096))),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(color: Color(0xFF718096)),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantRecommendations() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Restaurant Suggestions',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Based on 2k+ Traveller Reviews.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 2,
              mainAxisSpacing: 16,
            ),
            itemCount: _tripData?.restaurants.length ?? 0,
            itemBuilder: (context, index) {
              final restaurant = _tripData!.restaurants[index];
              return _buildRestaurantCard(restaurant, index);
            },
          ),
        ],
      ),
    );
  }

 Widget _buildRestaurantCard(Restaurant restaurant, int index) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // prevents unnecessary height expansion
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start, // allow multi-line title
          children: [
            Expanded(
              child: Text(
                restaurant.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (restaurant.rating.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8055),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: Color(0xFF1A1A1A),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.rating.split('/')[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          restaurant.details,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Row(
                children: [
                  _buildFoodTypeIcon(restaurant.foodType),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      restaurant.cuisine,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                      ),
                      overflow: TextOverflow.ellipsis, // prevents overflow
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            if (restaurant.timing.isNotEmpty)
              Flexible(
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: _primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        restaurant.timing,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    ),
  );
}


  Widget _buildFoodTypeIcon(String foodType) {
    switch (foodType) {
      case 'Veg':
        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF4CAF50), width: 2),
          ),
          child: const Center(
            child: CircleAvatar(
              radius: 4,
              backgroundColor: Color(0xFF4CAF50),
            ),
          ),
        );
      case 'Non-Veg':
        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE53935), width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.change_history,
              size: 8,
              color: Color(0xFFE53935),
            ),
          ),
        );
      case 'Veg/Non-Veg':
        return Row(
          children: [
            _buildFoodTypeIcon('Veg'),
            const SizedBox(width: 2),
            _buildFoodTypeIcon('Non-Veg'),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// Separate Loading Widget
class TripPlannerLoadingWidget extends StatefulWidget {
  final Color? primaryColor;
  final String? loadingText;
  
  const TripPlannerLoadingWidget({
    Key? key,
    this.primaryColor,
    this.loadingText,
  }) : super(key: key);

  @override
  State<TripPlannerLoadingWidget> createState() => _TripPlannerLoadingWidgetState();
}

class _TripPlannerLoadingWidgetState extends State<TripPlannerLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _currentIconAnimation;
  int _currentIconIndex = 0;
  Timer? _iconTimer;

  final List<IconData> _icons = [
    Icons.flight,
    Icons.restaurant,
    Icons.hotel,
    Icons.favorite,
    Icons.directions_bus,
  ];

  Color get _primaryColor => widget.primaryColor ?? const Color(0xFF0047FF);

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500), // Duration for each icon animation
      vsync: this,
    );

    _currentIconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _startSequentialAnimation();
  }

  void _startSequentialAnimation() {
    _animateCurrentIcon();
  }

  void _animateCurrentIcon() {
    _animationController.forward().then((_) {
      // Wait a bit, then fade out
      Timer(const Duration(milliseconds: 300), () {
        if (mounted) {
          _animationController.reverse().then((_) {
            if (mounted) {
              // Move to next icon
              setState(() {
                _currentIconIndex = (_currentIconIndex + 1) % _icons.length;
              });
              
              // Wait a bit before starting next icon
              Timer(const Duration(milliseconds: 200), () {
                if (mounted) {
                  _animateCurrentIcon();
                }
              });
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _iconTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: AnimatedBuilder(
              animation: _currentIconAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _currentIconAnimation.value,
                  child: Transform.scale(
                    scale: 0.7 + (_currentIconAnimation.value * 0.3),
                    child: Icon(
                      _icons[_currentIconIndex],
                      size: 80,
                      color: _primaryColor,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.loadingText ?? 'Crafting your perfect journey...',
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF555555),
            ),
          ),
        ],
      ),
    );
  }
}