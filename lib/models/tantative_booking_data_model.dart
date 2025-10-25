class TantativeBookingDataModel {
  int? status;
  String? message;
  Data? data;

  TantativeBookingDataModel({this.status, this.message, this.data});

  TantativeBookingDataModel.fromJson(Map<String, dynamic> json) {
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
  String? pnrNumber;
  String? operatorPnr;
  int? tentativeTimeInMillisec;
  String? tentativeExpiryTime;
  List<SeatFareDetails>? seatFareDetails;
  String? pnr; // backward compatible, still works everywhere
  Map<String, dynamic>? bookingInfo; // store full BookingInfo for future use

  Data(
      {this.pnrNumber,
      this.operatorPnr,
      this.tentativeTimeInMillisec,
      this.tentativeExpiryTime,
      this.seatFareDetails,
      this.pnr,
      this.bookingInfo,
      });

  Data.fromJson(Map<String, dynamic> json) {
    pnrNumber = json['pnr_number'];
    operatorPnr = json['operator_pnr'];
    tentativeTimeInMillisec = json['tentative_time_in_millisec'] != null
        ? json['tentative_time_in_millisec'].toInt()
        : 0;
    tentativeExpiryTime = json['tentative_expiry_time'];
    if (json['seat_fare_details'] != null) {
      seatFareDetails = <SeatFareDetails>[];
      json['seat_fare_details'].forEach((v) {
        seatFareDetails!.add(new SeatFareDetails.fromJson(v));
      });
    }
    // Save the full BookingInfo map
    bookingInfo = json['BookingInfo'] as Map<String, dynamic>?;

    // Populate the pnr from BookingInfo if available, fallback to json['pnr']
    pnr = bookingInfo?['PNR'] as String? ?? json['pnr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pnr_number'] = this.pnrNumber;
    data['operator_pnr'] = this.operatorPnr;
    data['tentative_time_in_millisec'] = this.tentativeTimeInMillisec;
    data['tentative_expiry_time'] = this.tentativeExpiryTime;
    if (this.seatFareDetails != null) {
      data['seat_fare_details'] =
          this.seatFareDetails!.map((v) => v.toJson()).toList();
    }
    data['pnr'] = this.pnr;
    if (bookingInfo != null) data['BookingInfo'] = bookingInfo;

    return data;
  }
}

class SeatFareDetails {
  SeatDetail? seatDetail;

  SeatFareDetails({this.seatDetail});

  SeatFareDetails.fromJson(Map<String, dynamic> json) {
    seatDetail = json['seat_detail'] != null
        ? new SeatDetail.fromJson(json['seat_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.seatDetail != null) {
      data['seat_detail'] = this.seatDetail!.toJson();
    }
    return data;
  }
}

class SeatDetail {
  String? seatNumber;
  int? fare;
  int? serviceTax;
  int? convenienceCharge;
  int? offerDiscount;
  int? discount;
  int? additionalFare;

  SeatDetail(
      {this.seatNumber,
      this.fare,
      this.serviceTax,
      this.convenienceCharge,
      this.offerDiscount,
      this.discount,
      this.additionalFare});

  SeatDetail.fromJson(Map<String, dynamic> json) {
    seatNumber = json['seat_number'];
    fare = json['fare'];
    serviceTax = json['service_tax'];
    convenienceCharge = json['convenience_charge'];
    offerDiscount = json['offer_discount'];
    discount = json['discount'];
    additionalFare = json['additional_fare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seat_number'] = this.seatNumber;
    data['fare'] = this.fare;
    data['service_tax'] = this.serviceTax;
    data['convenience_charge'] = this.convenienceCharge;
    data['offer_discount'] = this.offerDiscount;
    data['discount'] = this.discount;
    data['additional_fare'] = this.additionalFare;
    return data;
  }
}