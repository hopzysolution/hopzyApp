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
  Status? status;
  BookingInfo? bookingInfo;

  Data({this.status, this.bookingInfo});

  Data.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    bookingInfo = json['BookingInfo'] != null
        ? new BookingInfo.fromJson(json['BookingInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.bookingInfo != null) {
      data['BookingInfo'] = this.bookingInfo!.toJson();
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

class BookingInfo {
  String? pNR;
  String? validity;

  BookingInfo({this.pNR, this.validity});

  BookingInfo.fromJson(Map<String, dynamic> json) {
    pNR = json['PNR'];
    validity = json['Validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PNR'] = this.pNR;
    data['Validity'] = this.validity;
    return data;
  }
}