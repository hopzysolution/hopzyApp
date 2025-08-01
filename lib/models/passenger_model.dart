class Passenger {
  final String name;
  final int age;
  final String gender;
  final String? seatNo;
  final String? fare;

  Passenger(
      {required this.name,
      required this.age,
      required this.gender,
      this.seatNo,
      this.fare});

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'gender': gender,
        'seatNo': seatNo,
        'fare': fare,
      };

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      seatNo: json['seatNo'],
      fare: json['fare'],
    );
  }
}