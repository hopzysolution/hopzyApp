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

  Data(
      {this.gateway,
      this.action,
      this.payUData,
      this.userId,
      this.totalAmount,
      this.walletUsed,
      this.payuAmount,
      this.loggedIn});

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
      this.hash});

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
    return data;
  }
}