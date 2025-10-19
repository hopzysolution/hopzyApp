class ProfileDataModel {
  int? status;
  String? message;
  Data? data;

  ProfileDataModel({this.status, this.message, this.data});

  ProfileDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['status'] = status;
    map['message'] = message;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }
}

class Data {
  User? user;
  double? wallet;
  int? bookings;

  Data({this.user, this.wallet, this.bookings});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;

    // ✅ Safely convert wallet (handles int, double, string)
    final walletValue = json['wallet'];
    if (walletValue is int) {
      wallet = walletValue.toDouble();
    } else if (walletValue is double) {
      wallet = walletValue;
    } else if (walletValue is String) {
      wallet = double.tryParse(walletValue);
    } else {
      wallet = 0.0;
    }

    bookings = json['bookings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (user != null) map['user'] = user!.toJson();
    map['wallet'] = wallet;
    map['bookings'] = bookings;
    return map;
  }
}

class User {
  String? sId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  User({this.sId, this.firstName, this.lastName, this.email, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = sId;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['phone'] = phone;
    return map;
  }
}
