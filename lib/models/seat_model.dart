// lib/models/seat_model.dart
enum SeatStatus { available, booked, selected, ladies, unavailable }

class Seat {
  final String id;
  final SeatStatus status;
  final double price;
  final int row;
  final int column;
  final SeatType type;

  const Seat({
    required this.id,
    required this.status,
    required this.price,
    required this.row,
    required this.column,
    this.type = SeatType.regular,
  });

  Seat copyWith({
    String? id,
    SeatStatus? status,
    double? price,
    int? row,
    int? column,
    SeatType? type,
  }) {
    return Seat(
      id: id ?? this.id,
      status: status ?? this.status,
      price: price ?? this.price,
      row: row ?? this.row,
      column: column ?? this.column,
      type: type ?? this.type,
    );
  }

  bool get isSelectable =>
      status == SeatStatus.available ||
      status == SeatStatus.ladies ||
      status == SeatStatus.selected;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Seat && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum SeatType {
  regular,
  sleeper,
  premium,
}

extension SeatTypeExtension on SeatType {
  String get displayName {
    switch (this) {
      case SeatType.regular:
        return 'Regular';
      case SeatType.sleeper:
        return 'Sleeper';
      case SeatType.premium:
        return 'Premium';
    }
  }
}
