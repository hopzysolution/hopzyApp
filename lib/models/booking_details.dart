class BookingDetails {
  int? status;
  String? message;
  Data? data;

  BookingDetails({this.status, this.message, this.data});

  BookingDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  User? user;
  Payment? payment;
  String? ticketId;
  String? operatorName;
  String? pnr;
  String? routeId;
  String? tripId;
  String? from;
  String? to;
  BoardingPoint? boardingPoint;
  BoardingPoint? droppingPoint;
  String? bustype;
  String? seattype;
  int? numberOfSeats;
  int? totalFare;
  String? bookedAt;
  String? status;
  List<Passengers>? passengers;

  Data(
      {this.sId,
      this.user,
      this.payment,
      this.ticketId,
      this.operatorName,
      this.pnr,
      this.routeId,
      this.tripId,
      this.from,
      this.to,
      this.boardingPoint,
      this.droppingPoint,
      this.bustype,
      this.seattype,
      this.numberOfSeats,
      this.totalFare,
      this.bookedAt,
      this.status,
      this.passengers});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    ticketId = json['ticketId'];
    operatorName = json['operatorName'];
    pnr = json['pnr'];
    routeId = json['routeId'];
    tripId = json['tripId'];
    from = json['from'];
    to = json['to'];
    boardingPoint = json['boarding_point'] != null
        ? new BoardingPoint.fromJson(json['boarding_point'])
        : null;
    droppingPoint = json['dropping_point'] != null
        ? new BoardingPoint.fromJson(json['dropping_point'])
        : null;
    bustype = json['bustype'];
    seattype = json['seattype'];
    numberOfSeats = json['numberOfSeats'];
    totalFare = json['totalFare'];
    bookedAt = json['bookedAt'];
    status = json['status'];
    if (json['passengers'] != null) {
      passengers = <Passengers>[];
      json['passengers'].forEach((v) {
        passengers!.add(new Passengers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment!.toJson();
    }
    data['ticketId'] = this.ticketId;
    data['operatorName'] = this.operatorName;
    data['pnr'] = this.pnr;
    data['routeId'] = this.routeId;
    data['tripId'] = this.tripId;
    data['from'] = this.from;
    data['to'] = this.to;
    if (this.boardingPoint != null) {
      data['boarding_point'] = this.boardingPoint!.toJson();
    }
    if (this.droppingPoint != null) {
      data['dropping_point'] = this.droppingPoint!.toJson();
    }
    data['bustype'] = this.bustype;
    data['seattype'] = this.seattype;
    data['numberOfSeats'] = this.numberOfSeats;
    data['totalFare'] = this.totalFare;
    data['bookedAt'] = this.bookedAt;
    data['status'] = this.status;
    if (this.passengers != null) {
      data['passengers'] = this.passengers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String? sId;
  String? firstName;
  String? lastName;
  String? phone;

  User({this.sId, this.firstName, this.lastName, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    return data;
  }
}

class Payment {
  String? sId;
  String? razorpayOrderId;
  String? currency;
  String? status;
  String? razorpayPaymentId;

  Payment(
      {this.sId,
      this.razorpayOrderId,
      this.currency,
      this.status,
      this.razorpayPaymentId});

  Payment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    razorpayOrderId = json['razorpayOrderId'];
    currency = json['currency'];
    status = json['status'];
    razorpayPaymentId = json['razorpayPaymentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['razorpayOrderId'] = this.razorpayOrderId;
    data['currency'] = this.currency;
    data['status'] = this.status;
    data['razorpayPaymentId'] = this.razorpayPaymentId;
    return data;
  }
}

class BoardingPoint {
  String? id;
  String? name;
  String? time;

  BoardingPoint({this.id, this.name, this.time});

  BoardingPoint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['time'] = this.time;
    return data;
  }
}

class Passengers {
  String? sId;
  String? booking;
  String? name;
  String? gender;
  String? seatNo;
  int? age;
  int? fare;
  String? status;

  Passengers(
      {this.sId,
      this.booking,
      this.name,
      this.gender,
      this.seatNo,
      this.age,
      this.fare,
      this.status});

  Passengers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    booking = json['booking'];
    name = json['Name'];
    gender = json['gender'];
    seatNo = json['seatNo'];
    age = json['age'];
    fare = json['fare'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['booking'] = this.booking;
    data['Name'] = this.name;
    data['gender'] = this.gender;
    data['seatNo'] = this.seatNo;
    data['age'] = this.age;
    data['fare'] = this.fare;
    data['status'] = this.status;
    return data;
  }
}