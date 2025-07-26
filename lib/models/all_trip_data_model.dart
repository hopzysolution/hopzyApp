class AllTripDataModel {
  Status? status;
  List<Availabletrips>? availabletrips;

  AllTripDataModel({this.status, this.availabletrips});

  AllTripDataModel.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    if (json['availabletrips'] != null) {
      availabletrips = <Availabletrips>[];
      json['availabletrips'].forEach((v) {
        availabletrips!.add(new Availabletrips.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.availabletrips != null) {
      data['availabletrips'] =
          this.availabletrips!.map((v) => v.toJson()).toList();
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

class Availabletrips {
  String? operatorid;
  String? operatorname;
  String? routeid;
  String? tripid;
  String? srcid;
  String? dstid;
  String? srcname;
  String? dstname;
  String? depaturetime;
  String? arrivaltime;
  String? availseats;
  String? totalseats;
  String? bustype;
  String? subtripid;
  String? tripidV2;

  Availabletrips(
      {this.operatorid,
      this.operatorname,
      this.routeid,
      this.tripid,
      this.srcid,
      this.dstid,
      this.srcname,
      this.dstname,
      this.depaturetime,
      this.arrivaltime,
      this.availseats,
      this.totalseats,
      this.bustype,
      this.subtripid,
      this.tripidV2});

  Availabletrips.fromJson(Map<String, dynamic> json) {
    operatorid = json['operatorid'];
    operatorname = json['operatorname'];
    routeid = json['routeid'];
    tripid = json['tripid'];
    srcid = json['srcid'];
    dstid = json['dstid'];
    srcname = json['srcname'];
    dstname = json['dstname'];
    depaturetime = json['depaturetime'];
    arrivaltime = json['arrivaltime'];
    availseats = json['availseats'];
    totalseats = json['totalseats'];
    bustype = json['bustype'];
    subtripid = json['subtripid'];
    tripidV2 = json['tripid_v2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operatorid'] = this.operatorid;
    data['operatorname'] = this.operatorname;
    data['routeid'] = this.routeid;
    data['tripid'] = this.tripid;
    data['srcid'] = this.srcid;
    data['dstid'] = this.dstid;
    data['srcname'] = this.srcname;
    data['dstname'] = this.dstname;
    data['depaturetime'] = this.depaturetime;
    data['arrivaltime'] = this.arrivaltime;
    data['availseats'] = this.availseats;
    data['totalseats'] = this.totalseats;
    data['bustype'] = this.bustype;
    data['subtripid'] = this.subtripid;
    data['tripid_v2'] = this.tripidV2;
    return data;
  }
}