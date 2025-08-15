// 1. Models
class TripPlanRequest {
  final String destination;
  final int duration;
  final int people;
  final String travelStyle;

  TripPlanRequest({
    required this.destination,
    required this.duration,
    required this.people,
    required this.travelStyle,
  });

  Map<String, dynamic> toJson() => {
        'destination': destination,
        'duration': duration,
        'people': people,
        'travel_style': travelStyle,
      };
}

class Activity {
  final String name;
  final String description;
  final List<String> whyFamous;

  Activity({
    required this.name,
    required this.description,
    required this.whyFamous,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      whyFamous: List<String>.from(json['why_famous'] ?? []),
    );
  }
}

class DayItinerary {
  final int day;
  final String title;
  final List<Activity> activities;

  DayItinerary({
    required this.day,
    required this.title,
    required this.activities,
  });

  factory DayItinerary.fromJson(Map<String, dynamic> json) {
    return DayItinerary(
      day: json['day'] ?? 0,
      title: json['title'] ?? '',
      activities: (json['activities'] as List?)
              ?.map((activity) => Activity.fromJson(activity))
              .toList() ??
          [],
    );
  }
}

class Restaurant {
  final String name;
  final String cuisine;
  final String foodType;
  final String rating;
  final String details;
  final String timing;

  Restaurant({
    required this.name,
    required this.cuisine,
    required this.foodType,
    required this.rating,
    required this.details,
    required this.timing,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'] ?? '',
      cuisine: json['cuisine'] ?? '',
      foodType: json['food_type'] ?? '',
      rating: json['rating'] ?? '',
      details: json['details'] ?? '',
      timing: json['timing'] ?? '',
    );
  }
}

class TripPlan {
  final List<DayItinerary> itinerary;
  final List<Restaurant> restaurantRecommendations;
  final String? specialMessage;

  TripPlan({
    required this.itinerary,
    required this.restaurantRecommendations,
    this.specialMessage,
  });

  factory TripPlan.fromJson(Map<String, dynamic> json) {
    return TripPlan(
      itinerary: (json['itinerary'] as List?)
              ?.map((day) => DayItinerary.fromJson(day))
              .toList() ??
          [],
      restaurantRecommendations: (json['restaurant_recommendations'] as List?)
              ?.map((restaurant) => Restaurant.fromJson(restaurant))
              .toList() ??
          [],
      specialMessage: json['special_message'],
    );
  }
}