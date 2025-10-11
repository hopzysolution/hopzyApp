class CreateOrderDataModel {
  int? status;
  String? message;
  Data? data;

  CreateOrderDataModel({this.status, this.message, this.data});

  CreateOrderDataModel.fromJson(Map<String, dynamic> json) {
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
  String? gateway;
  String? action;
  PayUData? payUData;
  String? userId;
  int? totalAmount;
  int? walletUsed;
  int? payuAmount;
  bool? loggedIn;
  bool? welcomeCouponApplied;
  int? welcomeDiscount;
  String? serviceProvider;
  Hashes? hashes;

  Data(
      {this.gateway,
      this.action,
      this.payUData,
      this.userId,
      this.totalAmount,
      this.walletUsed,
      this.payuAmount,
      this.loggedIn,
      this.welcomeCouponApplied,
      this.welcomeDiscount,
      this.serviceProvider,
      this.hashes});

  Data.fromJson(Map<String, dynamic> json) {
    gateway = json['gateway'];
    action = json['action'];
    payUData = json['payUData'] != null
        ? new PayUData.fromJson(json['payUData'])
        : null;
    userId = json['user_id'];
    totalAmount = json['totalAmount'];
    walletUsed = json['walletUsed'];
    payuAmount = json['payuAmount'];
    loggedIn = json['loggedIn'];
    welcomeCouponApplied = json['welcomeCouponApplied'];
    welcomeDiscount = json['welcomeDiscount'];
    serviceProvider = json['service_provider'];
    hashes =
        json['hashes'] != null ? new Hashes.fromJson(json['hashes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gateway'] = this.gateway;
    data['action'] = this.action;
    if (this.payUData != null) {
      data['payUData'] = this.payUData!.toJson();
    }
    data['user_id'] = this.userId;
    data['totalAmount'] = this.totalAmount;
    data['walletUsed'] = this.walletUsed;
    data['payuAmount'] = this.payuAmount;
    data['loggedIn'] = this.loggedIn;
    data['welcomeCouponApplied'] = this.welcomeCouponApplied;
    data['welcomeDiscount'] = this.welcomeDiscount;
    data['service_provider'] = this.serviceProvider;
    if (this.hashes != null) {
      data['hashes'] = this.hashes!.toJson();
    }
    return data;
  }
}

class PayUData {
  String? key;
  String? txnid;
  String? amount;
  String? productinfo;
  String? firstname;
  String? email;
  String? phone;
  String? surl;
  String? furl;
  String? hash;
  String? udf1;
  String? udf2;
  String? udf3;
  String? udf4;
  String? udf5;

  PayUData(
      {this.key,
      this.txnid,
      this.amount,
      this.productinfo,
      this.firstname,
      this.email,
      this.phone,
      this.surl,
      this.furl,
      this.hash,
      this.udf1,
      this.udf2,
      this.udf3,
      this.udf4,
      this.udf5});

  PayUData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    txnid = json['txnid'];
    amount = json['amount'];
    productinfo = json['productinfo'];
    firstname = json['firstname'];
    email = json['email'];
    phone = json['phone'];
    surl = json['surl'];
    furl = json['furl'];
    hash = json['hash'];
    udf1 = json['udf1'];
    udf2 = json['udf2'];
    udf3 = json['udf3'];
    udf4 = json['udf4'];
    udf5 = json['udf5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['txnid'] = this.txnid;
    data['amount'] = this.amount;
    data['productinfo'] = this.productinfo;
    data['firstname'] = this.firstname;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['surl'] = this.surl;
    data['furl'] = this.furl;
    data['hash'] = this.hash;
    data['udf1'] = this.udf1;
    data['udf2'] = this.udf2;
    data['udf3'] = this.udf3;
    data['udf4'] = this.udf4;
    data['udf5'] = this.udf5;
    return data;
  }
}

class Hashes {
  String? payment;
  String? vasForMobileSdk;
  String? paymentRelatedDetailsForMobileSdk;

  Hashes(
      {this.payment,
      this.vasForMobileSdk,
      this.paymentRelatedDetailsForMobileSdk});

  Hashes.fromJson(Map<String, dynamic> json) {
    payment = json['payment'];
    vasForMobileSdk = json['vas_for_mobile_sdk'];
    paymentRelatedDetailsForMobileSdk =
        json['payment_related_details_for_mobile_sdk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment'] = this.payment;
    data['vas_for_mobile_sdk'] = this.vasForMobileSdk;
    data['payment_related_details_for_mobile_sdk'] =
        this.paymentRelatedDetailsForMobileSdk;
    return data;
  }
}