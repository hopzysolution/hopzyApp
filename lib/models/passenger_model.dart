class Passenger {
  final String name;
  final int age;
  final String gender;
  final String? seatNo;
  final int? fare;
  final String? seatCode; // Added optional seatCode parameter

  Passenger({
    required this.name,
    required this.age,
    required this.gender,
    this.seatNo,
    this.fare,
    this.seatCode, // Optional parameter
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'Name': name,
      'age': age,
      'gender': gender,
      'seatNo': seatNo,
      'fare': fare,
    };
    
    // Only add seatCode if it's not null
    if (seatCode != null) {
      json['seatCode'] = seatCode;
    }
    
    return json;
  }

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      name: json['Name'],
      age: json['age'],
      gender: json['gender'],
      seatNo: json['seatNo'],
      fare: json['fare'],
    );
  }

  factory Passenger.fromJsonEzee(Map<String, dynamic> json) {
    return Passenger(
      name: json['Name'],
      age: json['age'],
      gender: json['gender'],
      seatNo: json['seatNo'],
      fare: json['fare'],
      seatCode: json['seatCode'], // Will be null if not present in JSON
    );
  }
}