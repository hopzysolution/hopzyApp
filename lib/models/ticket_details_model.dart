class TicketDetailsModel {
  Status? status;
  TicketDetails? ticketDetails;

  TicketDetailsModel({this.status, this.ticketDetails});

  TicketDetailsModel.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    ticketDetails = json['ticketDetails'] != null
        ? new TicketDetails.fromJson(json['ticketDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.ticketDetails != null) {
      data['ticketDetails'] = this.ticketDetails!.toJson();
    }
    return data;
  }
}

class Status {
  bool? success;
  String? message;
  Profiledata? profiledata;
  int? code;

  Status({this.success, this.message, this.profiledata, this.code});

  Status.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    profiledata = json['profiledata'] != null
        ? new Profiledata.fromJson(json['profiledata'])
        : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.profiledata != null) {
      data['profiledata'] = this.profiledata!.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class Profiledata {
  String? balance;
  String? mode;
  String? name;
  String? allowopsids;

  Profiledata({this.balance, this.mode, this.name, this.allowopsids});

  Profiledata.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    mode = json['mode'];
    name = json['name'];
    allowopsids = json['allowopsids'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['mode'] = this.mode;
    data['name'] = this.name;
    data['allowopsids'] = this.allowopsids;
    return data;
  }
}

class TicketDetails {
  String? operatorName;
  String? operatorId;
  String? busType;
  String? dateOfIssue;
  String? sourceCity;
  String? sourceCityId;
  String? destinationCity;
  String? destinationCityId;
  String? doj;
  String? dropLocation;
  String? dropLocationAddress;
  String? dropLocationId;
  String? dropTime;
  String? pickUpContactNo;
  String? pickUpLocationAddress;
  String? pickupLocation;
  String? pickupLocationId;
  String? pickupTime;
  String? pnr;
  String? primeDepartureTime;
  String? dropdttime;
  String? pickupdttime;
  String? servicestarttime;
  String? status;
  List<SeatDetails>? seatDetails;
  String? commaSepSeats;
  String? custMobNo;
  int? bookingFee;
  int? bookingStax;
  List<CancellationPolicy>? cancellationPolicy;
  List<CancellationRefundPolicy>? cancellationRefundPolicy;

  TicketDetails(
      {this.operatorName,
      this.operatorId,
      this.busType,
      this.dateOfIssue,
      this.sourceCity,
      this.sourceCityId,
      this.destinationCity,
      this.destinationCityId,
      this.doj,
      this.dropLocation,
      this.dropLocationAddress,
      this.dropLocationId,
      this.dropTime,
      this.pickUpContactNo,
      this.pickUpLocationAddress,
      this.pickupLocation,
      this.pickupLocationId,
      this.pickupTime,
      this.pnr,
      this.primeDepartureTime,
      this.dropdttime,
      this.pickupdttime,
      this.servicestarttime,
      this.status,
      this.seatDetails,
      this.commaSepSeats,
      this.custMobNo,
      this.bookingFee,
      this.bookingStax,
      this.cancellationPolicy,
      this.cancellationRefundPolicy});

  TicketDetails.fromJson(Map<String, dynamic> json) {
    operatorName = json['OperatorName'];
    operatorId = json['OperatorId'];
    busType = json['busType'];
    dateOfIssue = json['dateOfIssue'];
    sourceCity = json['sourceCity'];
    sourceCityId = json['sourceCityId'];
    destinationCity = json['destinationCity'];
    destinationCityId = json['destinationCityId'];
    doj = json['doj'];
    dropLocation = json['dropLocation'];
    dropLocationAddress = json['dropLocationAddress'];
    dropLocationId = json['dropLocationId'];
    dropTime = json['dropTime'];
    pickUpContactNo = json['pickUpContactNo'];
    pickUpLocationAddress = json['pickUpLocationAddress'];
    pickupLocation = json['pickupLocation'];
    pickupLocationId = json['pickupLocationId'];
    pickupTime = json['pickupTime'];
    pnr = json['pnr'];
    primeDepartureTime = json['primeDepartureTime'];
    dropdttime = json['dropdttime'];
    pickupdttime = json['pickupdttime'];
    servicestarttime = json['servicestarttime'];
    status = json['status'];
    if (json['seatDetails'] != null) {
      seatDetails = <SeatDetails>[];
      json['seatDetails'].forEach((v) {
        seatDetails!.add(new SeatDetails.fromJson(v));
      });
    }
    commaSepSeats = json['commaSepSeats'];
    custMobNo = json['custMobNo'];
    bookingFee = json['bookingFee'];
    bookingStax = json['bookingStax'];
    if (json['cancellationPolicy'] != null) {
      cancellationPolicy = <CancellationPolicy>[];
      json['cancellationPolicy'].forEach((v) {
        cancellationPolicy!.add(new CancellationPolicy.fromJson(v));
      });
    }
    if (json['cancellationRefundPolicy'] != null) {
      cancellationRefundPolicy = <CancellationRefundPolicy>[];
      json['cancellationRefundPolicy'].forEach((v) {
        cancellationRefundPolicy!.add(new CancellationRefundPolicy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OperatorName'] = this.operatorName;
    data['OperatorId'] = this.operatorId;
    data['busType'] = this.busType;
    data['dateOfIssue'] = this.dateOfIssue;
    data['sourceCity'] = this.sourceCity;
    data['sourceCityId'] = this.sourceCityId;
    data['destinationCity'] = this.destinationCity;
    data['destinationCityId'] = this.destinationCityId;
    data['doj'] = this.doj;
    data['dropLocation'] = this.dropLocation;
    data['dropLocationAddress'] = this.dropLocationAddress;
    data['dropLocationId'] = this.dropLocationId;
    data['dropTime'] = this.dropTime;
    data['pickUpContactNo'] = this.pickUpContactNo;
    data['pickUpLocationAddress'] = this.pickUpLocationAddress;
    data['pickupLocation'] = this.pickupLocation;
    data['pickupLocationId'] = this.pickupLocationId;
    data['pickupTime'] = this.pickupTime;
    data['pnr'] = this.pnr;
    data['primeDepartureTime'] = this.primeDepartureTime;
    data['dropdttime'] = this.dropdttime;
    data['pickupdttime'] = this.pickupdttime;
    data['servicestarttime'] = this.servicestarttime;
    data['status'] = this.status;
    if (this.seatDetails != null) {
      data['seatDetails'] = this.seatDetails!.map((v) => v.toJson()).toList();
    }
    data['commaSepSeats'] = this.commaSepSeats;
    data['custMobNo'] = this.custMobNo;
    data['bookingFee'] = this.bookingFee;
    data['bookingStax'] = this.bookingStax;
    if (this.cancellationPolicy != null) {
      data['cancellationPolicy'] =
          this.cancellationPolicy!.map((v) => v.toJson()).toList();
    }
    if (this.cancellationRefundPolicy != null) {
      data['cancellationRefundPolicy'] =
          this.cancellationRefundPolicy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SeatDetails {
  String? seatName;
  String? fare;
  String? age;
  String? email;
  String? gender;
  String? serviceTax;
  String? mobile;
  String? name;
  String? seatStatus;

  SeatDetails(
      {this.seatName,
      this.fare,
      this.age,
      this.email,
      this.gender,
      this.serviceTax,
      this.mobile,
      this.name,
      this.seatStatus});

  SeatDetails.fromJson(Map<String, dynamic> json) {
    seatName = json['seatName'];
    fare = json['fare'];
    age = json['age'];
    email = json['email'];
    gender = json['gender'];
    serviceTax = json['serviceTax'];
    mobile = json['mobile'];
    name = json['name'];
    seatStatus = json['seatStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seatName'] = this.seatName;
    data['fare'] = this.fare;
    data['age'] = this.age;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['serviceTax'] = this.serviceTax;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['seatStatus'] = this.seatStatus;
    return data;
  }
}

class CancellationPolicy {
  String? refundpercent;
  String? description;
  String? cancellationcharge;
  String? hourcondition;

  CancellationPolicy(
      {this.refundpercent,
      this.description,
      this.cancellationcharge,
      this.hourcondition});

  CancellationPolicy.fromJson(Map<String, dynamic> json) {
    refundpercent = json['refundpercent'];
    description = json['description'];
    cancellationcharge = json['cancellationcharge'];
    hourcondition = json['hourcondition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refundpercent'] = this.refundpercent;
    data['description'] = this.description;
    data['cancellationcharge'] = this.cancellationcharge;
    data['hourcondition'] = this.hourcondition;
    return data;
  }
}

class CancellationRefundPolicy {
  String? description;
  String? cancellationcharge;

  CancellationRefundPolicy({this.description, this.cancellationcharge});

  CancellationRefundPolicy.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    cancellationcharge = json['cancellationcharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['cancellationcharge'] = this.cancellationcharge;
    return data;
  }
}