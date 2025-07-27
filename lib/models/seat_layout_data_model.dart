class SeatLayoutDataModel {
  Status? status;
  Layout? layout;

  SeatLayoutDataModel({this.status, this.layout});

  SeatLayoutDataModel.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    layout =
        json['layout'] != null ? new Layout.fromJson(json['layout']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.layout != null) {
      data['layout'] = this.layout!.toJson();
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

class Layout {
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

  Layout(
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

  Layout.fromJson(Map<String, dynamic> json) {
    maxrows = json['maxrows'];
    seattype = json['seattype'];
    maxcols = json['maxcols'];
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
  Null? gender;
  String? seattype;
  String? berth;

  SeatInfo(
      {this.seatNo,
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
    seatNo = json['seatNo'];
    fare = json['fare'];
    servicetax = json['servicetax'];
    isac = json['isac'];
    stperc = json['stperc'];
    convenienceChargePercent = json['convenienceChargePercent'];
    seatstatus = json['seatstatus'];
    position = json['position'];
    row = json['row'];
    col = json['col'];
    gender = json['gender'];
    seattype = json['seattype'];
    berth = json['berth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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