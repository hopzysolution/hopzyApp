import 'dart:convert';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/passenger_model.dart';
import 'package:ridebooking/models/profile_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static String userIdKey = "USERKEY";
  static String fullName = "fullName";
  static String dateOfBirth = "dateOfBirth";
  static String dateOfTime = "dateOfTime";
  static String dateOfPlace = "dateOfPlace";
  static String gender = "gender";  
  static String userImageKey = "userImageKey";
   static const String _keyPhoneNo = 'phone_no';
  static const String _keyProfileData = 'profile_data';
  static const String _keyAllSeats = 'all_seats';
  static const String _keyWalletBalance = 'wallet_balance';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';


  // Save complete ProfileDataModel
  static Future<void> saveProfileData(ProfileDataModel profileDataModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Convert the model to JSON string
      String jsonString = jsonEncode(profileDataModel.toJson());
      
      // Save to SharedPreferences
      await prefs.setString(_keyProfileData, jsonString);
      
     
      
      print("Profile data saved successfully");
    } catch (e) {
      print("Error saving profile data: $e");
    }
  }

  // Get complete ProfileDataModel
  static Future<ProfileDataModel?> getProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get JSON string from SharedPreferences
      String? jsonString = prefs.getString(_keyProfileData);
      
      if (jsonString != null && jsonString.isNotEmpty) {
        // Convert JSON string back to model
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        ProfileDataModel profileDataModel = ProfileDataModel.fromJson(jsonMap);
        
        print("Profile data retrieved successfully-------->>>");
        return profileDataModel;
      } else {
        print("No profile data found in session");
        return null;
      }
    } catch (e) {
      print("Error getting profile data: $e");
      return null;
    }
  }

 Future<String> getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString(Session.fullName);
    return fullName ?? "";
  }

  Future<bool> setFullName(String setFullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(fullName, setFullName);
  }

  
  //  Future<bool> setUserImage(String getUserImage) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString(userImageKey, getUserImage);
  // }

  
  // Future<String?> getUserImage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(userImageKey);
  // }

   Future<String?> getPhoneNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("phoneNo");
  }



   Future<bool> setPhoneNo(String phoneNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("phoneNo", phoneNo);
  }

 

   Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("accessToken");
    return token ?? "";
  }

  Future<bool> setToken(String setToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    return prefs.setString("accessToken", setToken);
  }

Future<String> getHopzyAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("hopzyAccessToken");
    return token ?? "";
  }

  Future<bool> setHopzyAccessToken(String setToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    return prefs.setString("hopzyAccessToken", setToken);
  }

 Future<String> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("refreshToken");
    return token ?? "";
  }

  Future<bool> setRefreshToken(String setToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    return prefs.setString("refreshToken", setToken);
  }



  Future<String> getEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('email') ?? '';
}

Future<void> setEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
}

Future<void> saveTripsToSession(List<Trips> trips) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> tripList = trips.map((trip) => jsonEncode(trip.toJson())).toList();
  await prefs.setStringList('available_trips', tripList);
}

Future<List<Trips>> getTripsFromSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? tripList = prefs.getStringList('available_trips');

  if (tripList != null) {
    return tripList
        .map((tripString) => Trips.fromJson(jsonDecode(tripString)))
        .toList();
  } else {
    return [];
  }
}



  static const _key = 'passenger_list';

  static Future<void> savePassenger(Passenger passenger) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getPassengers();
    list.add(passenger);

    final jsonList = list.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<void> saveAllSelectedPassengers(List<Passenger> passengers) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = passengers.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList("selected", jsonList);
  }
 
   static Future<List<Passenger>> getAllSelectedPassengers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("selected") ?? [];
    return jsonList.map((e) => Passenger.fromJson(jsonDecode(e))).toList();
  }

    static Future<void> saveAllPassengers(List<Passenger> passengers) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = passengers.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  static Future<List<Passenger>> getPassengers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((e) => Passenger.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> saveAllSeats(List<String> allSeats) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList("allSeats", allSeats.toList());
}

 static Future<List<String>> getAllSeats() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("allSeats") ?? [];
  }


static Future<void> saveAllSelectedSeats(Set<String> saveAllSelectedSeats) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList("selectedSeats", saveAllSelectedSeats.toList());
}


static Future<Set<String>> getAllSelectedSeats() async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList("selectedSeats") ?? [];
  return list.toSet();
}


  Future<String> getPnr() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('pnr') ?? '';
}

Future<void> setPnr(String pnr) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('pnr', pnr);
}

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  }



}
