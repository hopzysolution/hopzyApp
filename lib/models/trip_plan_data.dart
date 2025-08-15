class TripPlanData {
  final List<DayPlan> itinerary;
  final List<Restaurant> restaurants;
  final String? specialMessage;

  TripPlanData({
    required this.itinerary,
    required this.restaurants,
    this.specialMessage,
  });

  factory TripPlanData.fromJson(Map<String, dynamic> json) {
    return TripPlanData(
      itinerary: (json['itinerary'] as List<dynamic>?)
          ?.map((dayJson) => DayPlan.fromJson(dayJson as Map<String, dynamic>))
          .toList() ?? [],
      restaurants: (json['restaurant_recommendations'] as List<dynamic>?)
          ?.map((restJson) => Restaurant.fromJson(restJson as Map<String, dynamic>))
          .toList() ?? [],
      specialMessage: json['special_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itinerary': itinerary.map((day) => day.toJson()).toList(),
      'restaurant_recommendations': restaurants.map((restaurant) => restaurant.toJson()).toList(),
      'special_message': specialMessage,
    };
  }
}

class DayPlan {
  final int day;
  final String title;
  final List<Activity> activities;

  DayPlan({
    required this.day,
    required this.title,
    required this.activities,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      day: json['day'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      activities: (json['activities'] as List<dynamic>?)
          ?.map((activityJson) => Activity.fromJson(activityJson as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'title': title,
      'activities': activities.map((activity) => activity.toJson()).toList(),
    };
  }
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
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      whyFamous: (json['why_famous'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'why_famous': whyFamous,
    };
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
      name: json['name'] as String? ?? '',
      cuisine: json['cuisine'] as String? ?? '',
      foodType: json['food_type'] as String? ?? '',
      rating: json['rating'] as String? ?? '',
      details: json['details'] as String? ?? '',
      timing: json['timing'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cuisine': cuisine,
      'food_type': foodType,
      'rating': rating,
      'details': details,
      'timing': timing,
    };
  }
}