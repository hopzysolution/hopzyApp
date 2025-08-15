// 4. Repository
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ridebooking/models/trip_plan_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripPlannerRepository {
  static const String baseUrl = 'YOUR_API_URL'; // Replace with your Flask app URL
  static const String recentSearchesKey = 'recent_trip_searches';

  Future<TripPlan> generateTripPlan(TripPlanRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/plan-trip'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TripPlan.fromJson(data);
      } else {
        throw Exception('Failed to generate trip plan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList(recentSearchesKey) ?? [];
    return searches;
  }

  Future<void> saveRecentSearch(String destination) async {
    if (destination.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    List<String> searches = prefs.getStringList(recentSearchesKey) ?? [];
    
    // Remove if already exists
    searches.removeWhere((item) => item.toLowerCase() == destination.toLowerCase());
    
    // Add to beginning
    searches.insert(0, destination);
    
    // Keep only top 5
    if (searches.length > 5) {
      searches = searches.take(5).toList();
    }
    
    await prefs.setStringList(recentSearchesKey, searches);
  }
}