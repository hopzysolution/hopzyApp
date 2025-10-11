class SeatLayoutDataModel {
  int? status;
  String? message;
  Data? data;

  SeatLayoutDataModel({this.status, this.message, this.data});

  SeatLayoutDataModel.fromJson(Map<String, dynamic> json) {
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
  String? maxrows;
  String? seattype;
  String? maxcols;
  String? decktype;
  String? isenbldsocialdistancing;
  String? covidblockedseats;
  String? blockingtype;
  String? cancellationrefrncetime;
  Cancellationpolicy? cancellationpolicy;
  List<SeatInfo>? seatInfo;

  Data(
      {this.maxrows,
      this.seattype,
      this.maxcols,
      this.decktype,
      this.isenbldsocialdistancing,
      this.covidblockedseats,
      this.blockingtype,
      this.cancellationrefrncetime,
      this.cancellationpolicy,
      this.seatInfo});

  Data.fromJson(Map<String, dynamic> json) {
    maxrows = json['maxrows'].toString();
    seattype = json['seattype'];
    maxcols = json['maxcols'].toString();
    decktype = json['decktype'];
    isenbldsocialdistancing = json['isenbldsocialdistancing'];
    covidblockedseats = json['covidblockedseats'];
    blockingtype = json['blockingtype'];
    cancellationrefrncetime = json['cancellationrefrncetime'];
    cancellationpolicy = json['cancellationpolicy'] != null
        ? new Cancellationpolicy.fromJson(json['cancellationpolicy'])
        : null;
    if (json['seatInfo'] != null) {
      seatInfo = <SeatInfo>[];
      json['seatInfo'].forEach((v) {
        seatInfo!.add(new SeatInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maxrows'] = this.maxrows;
    data['seattype'] = this.seattype;
    data['maxcols'] = this.maxcols;
    data['decktype'] = this.decktype;
    data['isenbldsocialdistancing'] = this.isenbldsocialdistancing;
    data['covidblockedseats'] = this.covidblockedseats;
    data['blockingtype'] = this.blockingtype;
    data['cancellationrefrncetime'] = this.cancellationrefrncetime;
    if (this.cancellationpolicy != null) {
      data['cancellationpolicy'] = this.cancellationpolicy!.toJson();
    }
    if (this.seatInfo != null) {
      data['seatInfo'] = this.seatInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cancellationpolicy {
  List<Terms>? terms;

  Cancellationpolicy({this.terms});

  Cancellationpolicy.fromJson(Map<String, dynamic> json) {
    if (json['terms'] != null) {
      terms = <Terms>[];
      json['terms'].forEach((v) {
        terms!.add(new Terms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.terms != null) {
      data['terms'] = this.terms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Terms {
  String? hoursbefore;
  String? description;
  String? refundpercentage;
  String? cancellationpercentage;

  Terms(
      {this.hoursbefore,
      this.description,
      this.refundpercentage,
      this.cancellationpercentage});

  Terms.fromJson(Map<String, dynamic> json) {
    hoursbefore = json['hoursbefore'];
    description = json['description'];
    refundpercentage = json['refundpercentage'];
    cancellationpercentage = json['cancellationpercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hoursbefore'] = this.hoursbefore;
    data['description'] = this.description;
    data['refundpercentage'] = this.refundpercentage;
    data['cancellationpercentage'] = this.cancellationpercentage;
    return data;
  }
}

class SeatInfo {
  String? seatCode;
  String? seatNo;
  int? fare;
  int? servicetax;
  bool? isac;
  String? stperc;
  int? convenienceChargePercent;
  String? seatstatus;
  String? position;
  String? row;
  String? col;
  String? gender;
  String? seattype;
  String? berth;

  SeatInfo(
      {this.seatCode,
      this.seatNo,
      this.fare,
      this.servicetax,
      this.isac,
      this.stperc,
      this.convenienceChargePercent,
      this.seatstatus,
      this.position,
      this.row,
      this.col,
      this.gender,
      this.seattype,
      this.berth});

  SeatInfo.fromJson(Map<String, dynamic> json) {
    seatCode = json['seatCode'];
    seatNo = json['seatNo'];
    fare = json['fare'];
    servicetax = json['servicetax'].toInt();
    isac = json['isac'];
    stperc = json['stperc'];
    convenienceChargePercent = json['convenienceChargePercent'];
    seatstatus = json['seatstatus'];
    position = json['position'];
    row = json['row'].toString();
    col = json['col'].toString();
    gender = json['gender'];
    seattype = json['seattype'];
    berth = json['berth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seatCode'] = this.seatCode;
    data['seatNo'] = this.seatNo;
    data['fare'] = this.fare;
    data['servicetax'] = this.servicetax;
    data['isac'] = this.isac;
    data['stperc'] = this.stperc;
    data['convenienceChargePercent'] = this.convenienceChargePercent;
    data['seatstatus'] = this.seatstatus;
    data['position'] = this.position;
    data['row'] = this.row;
    data['col'] = this.col;
    data['gender'] = this.gender;
    data['seattype'] = this.seattype;
    data['berth'] = this.berth;
    return data;
  }
}