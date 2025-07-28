class BusData {
  int? totalRows;
  int? totalColumns;
  List<Seats>? seats;

  BusData({this.totalRows, this.totalColumns, this.seats});

  BusData.fromJson(Map<String, dynamic> json) {
    totalRows = json['totalRows'];
    totalColumns = json['totalColumns'];
    if (json['seats'] != null) {
      seats = <Seats>[];
      json['seats'].forEach((v) {
        seats!.add(Seats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalRows'] = this.totalRows;
    data['totalColumns'] = this.totalColumns;
    if (this.seats != null) {
      data['seats'] = this.seats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Seats {
  String? seatNumber;
  int? row;
  int? column;
  String? status;
  int? fare;
  String? berth;
  String? gender;
  String? seatType; // new: 'sleeper' or 'seater'
  bool? isAC; // new: true or false
  int? tax; // new: tax in integer (e.g. 50)

  Seats({
    this.seatNumber,
    this.row,
    this.column,
    this.status,
    this.fare,
    this.berth,
    this.gender,
    this.seatType,
    this.isAC,
    this.tax,
  });

  Seats.fromJson(Map<String, dynamic> json) {
    seatNumber = json['seatNumber'];
    row = json['row'];
    column = json['column'];
    status = json['status'];
    fare = json['fare'];
    berth = json['berth'];
    gender = json['gender'];
    seatType = json['seatType'];
    isAC = json['isAC'];
    tax = json['tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seatNumber'] = this.seatNumber;
    data['row'] = this.row;
    data['column'] = this.column;
    data['status'] = this.status;
    data['fare'] = this.fare;
    data['berth'] = this.berth;
    data['gender'] = this.gender;
    data['seatType'] = this.seatType;
    data['isAC'] = this.isAC;
    data['tax'] = this.tax;
    return data;
  }
}