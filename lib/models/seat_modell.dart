class SeatModell{
  final String seatNo;
  final int fare;
  final String available;
  final String? seatCode;

  SeatModell({
    required this.seatNo,
    required this.fare,
    required this.available,
    this.seatCode,
  });

  factory SeatModell.fromJson(Map<String, dynamic> json) {
    return SeatModell(
      seatNo: json['seatNo'] ?? '',
      fare: json['fare'] is int
          ? json['fare']
          : int.tryParse(json['fare']?.toString() ?? '0') ?? 0,
      available: json['seatstatus'] ?? '',
      seatCode: json['seatCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seatNo': seatNo,
      'fare': fare,
      'seatstatus': available,
      'seatCode': seatCode,
    };
  }

  @override
  String toString() =>
      'SeatModel(seatNo: $seatNo, fare: $fare, available: $available)';
}
