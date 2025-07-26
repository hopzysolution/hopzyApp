class TripModel {
  final String operatorId;
  final String operatorName;
  final String routeId;
  final String tripId;
  final String srcName;
  final String dstName;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String availableSeats;
  final String totalSeats;
  final String busType;
  final String tripIdV2;
  final String? price;

  TripModel({
    required this.operatorId,
    required this.operatorName,
    required this.routeId,
    required this.tripId,
    required this.srcName,
    required this.dstName,
    required this.departureTime,
    required this.arrivalTime,
    required this.availableSeats,
    required this.totalSeats,
    required this.busType,
    required this.tripIdV2,
    required this.price,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      operatorId: json['operatorid'],
      operatorName: json['operatorname'],
      routeId: json['routeid'],
      tripId: json['tripid'],
      srcName: json['srcname'],
      dstName: json['dstname'],
      departureTime: DateTime.parse(json['depaturetime']),
      arrivalTime: DateTime.parse(json['arrivaltime']),
      availableSeats: json['availseats'].toString(),
      totalSeats: json['totalseats'].toString(),
      busType: json['bustype'],
      tripIdV2: json['tripid_v2'],
      price: json['price']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'operatorid': operatorId,
      'operatorname': operatorName,
      'routeid': routeId,
      'tripid': tripId,
      'srcname': srcName,
      'dstname': dstName,
      'depaturetime': departureTime.toIso8601String(),
      'arrivaltime': arrivalTime.toIso8601String(),
      'availseats': availableSeats,
      'totalseats': totalSeats,
      'bustype': busType,
      'tripid_v2': tripIdV2,
      'price': price,
    };
  }
}
