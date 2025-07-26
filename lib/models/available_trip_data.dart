class GetAvailableTrips {
  Status? status;
  List<Availabletrips>? availabletrips;

  GetAvailableTrips({this.status, this.availabletrips});

  GetAvailableTrips.fromJson(Map<String, dynamic> json) {
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
  String? tripidV2;
  String? subtripid;
  String? bustype;
  String? totalseats;
  String? availseats;
  String? ispinksr;
  bool? isAvailReschedule;
  int? reschedulePolicy;
  int? rescheduleFare;
  String? fare;
  int? servicetax;
  bool? isac;
  String? seattype;
  int? convenienceChargePercent;
  String? src;
  String? srcorder;
  String? dst;
  String? dstorder;
  String? deptime;
  String? arrtime;
  String? vehiclenumber;
  String? amenities;
  String? schnote;
  String? isenbldsocialdistancing;
  String? blockingtype;
  Boardingpoint? boardingpoint;
  Droppingpoint? droppingpoint;
  String? cancellationrefrncetime;
  Cancellationpolicy? cancellationpolicy;

  Availabletrips(
      {this.operatorid,
      this.operatorname,
      this.routeid,
      this.tripid,
      this.tripidV2,
      this.subtripid,
      this.bustype,
      this.totalseats,
      this.availseats,
      this.ispinksr,
      this.isAvailReschedule,
      this.reschedulePolicy,
      this.rescheduleFare,
      this.fare,
      this.servicetax,
      this.isac,
      this.seattype,
      this.convenienceChargePercent,
      this.src,
      this.srcorder,
      this.dst,
      this.dstorder,
      this.deptime,
      this.arrtime,
      this.vehiclenumber,
      this.amenities,
      this.schnote,
      this.isenbldsocialdistancing,
      this.blockingtype,
      this.boardingpoint,
      this.droppingpoint,
      this.cancellationrefrncetime,
      this.cancellationpolicy});

  Availabletrips.fromJson(Map<String, dynamic> json) {
    operatorid = json['operatorid'];
    operatorname = json['operatorname'];
    routeid = json['routeid'];
    tripid = json['tripid'];
    tripidV2 = json['tripid_v2'];
    subtripid = json['subtripid'];
    bustype = json['bustype'];
    totalseats = json['totalseats'];
    availseats = json['availseats'];
    ispinksr = json['ispinksr'];
    isAvailReschedule = json['isAvailReschedule'];
    reschedulePolicy = json['reschedulePolicy'];
    rescheduleFare = json['rescheduleFare'];
    fare = json['fare'];
    servicetax = json['servicetax'];
    isac = json['isac'];
    seattype = json['seattype'];
    convenienceChargePercent = json['convenienceChargePercent'];
    src = json['src'];
    srcorder = json['srcorder'];
    dst = json['dst'];
    dstorder = json['dstorder'];
    deptime = json['deptime'];
    arrtime = json['arrtime'];
    vehiclenumber = json['vehiclenumber'];
    amenities = json['amenities'];
    schnote = json['schnote'];
    isenbldsocialdistancing = json['isenbldsocialdistancing'];
    blockingtype = json['blockingtype'];
    boardingpoint = json['boardingpoint'] != null
        ? new Boardingpoint.fromJson(json['boardingpoint'])
        : null;
    droppingpoint = json['droppingpoint'] != null
        ? new Droppingpoint.fromJson(json['droppingpoint'])
        : null;
    cancellationrefrncetime = json['cancellationrefrncetime'];
    cancellationpolicy = json['cancellationpolicy'] != null
        ? new Cancellationpolicy.fromJson(json['cancellationpolicy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['operatorid'] = this.operatorid;
    data['operatorname'] = this.operatorname;
    data['routeid'] = this.routeid;
    data['tripid'] = this.tripid;
    data['tripid_v2'] = this.tripidV2;
    data['subtripid'] = this.subtripid;
    data['bustype'] = this.bustype;
    data['totalseats'] = this.totalseats;
    data['availseats'] = this.availseats;
    data['ispinksr'] = this.ispinksr;
    data['isAvailReschedule'] = this.isAvailReschedule;
    data['reschedulePolicy'] = this.reschedulePolicy;
    data['rescheduleFare'] = this.rescheduleFare;
    data['fare'] = this.fare;
    data['servicetax'] = this.servicetax;
    data['isac'] = this.isac;
    data['seattype'] = this.seattype;
    data['convenienceChargePercent'] = this.convenienceChargePercent;
    data['src'] = this.src;
    data['srcorder'] = this.srcorder;
    data['dst'] = this.dst;
    data['dstorder'] = this.dstorder;
    data['deptime'] = this.deptime;
    data['arrtime'] = this.arrtime;
    data['vehiclenumber'] = this.vehiclenumber;
    data['amenities'] = this.amenities;
    data['schnote'] = this.schnote;
    data['isenbldsocialdistancing'] = this.isenbldsocialdistancing;
    data['blockingtype'] = this.blockingtype;
    if (this.boardingpoint != null) {
      data['boardingpoint'] = this.boardingpoint!.toJson();
    }
    if (this.droppingpoint != null) {
      data['droppingpoint'] = this.droppingpoint!.toJson();
    }
    data['cancellationrefrncetime'] = this.cancellationrefrncetime;
    if (this.cancellationpolicy != null) {
      data['cancellationpolicy'] = this.cancellationpolicy!.toJson();
    }
    return data;
  }
}

class Boardingpoint {
  List<BpDetails>? bpDetails;

  Boardingpoint({this.bpDetails});

  Boardingpoint.fromJson(Map<String, dynamic> json) {
    if (json['bpDetails'] != null) {
      bpDetails = <BpDetails>[];
      json['bpDetails'].forEach((v) {
        bpDetails!.add(new BpDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bpDetails != null) {
      data['bpDetails'] = this.bpDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BpDetails {
  String? id;
  String? venue;
  String? glbid;
  String? stnname;
  String? address;
  String? contactno;
  String? boardtime;
  String? td;
  String? status;
  String? stationid;
  String? tripid;
  String? sid;
  String? timedelay;

  BpDetails(
      {this.id,
      this.venue,
      this.glbid,
      this.stnname,
      this.address,
      this.contactno,
      this.boardtime,
      this.td,
      this.status,
      this.stationid,
      this.tripid,
      this.sid,
      this.timedelay});

  BpDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    venue = json['venue'];
    glbid = json['glbid'];
    stnname = json['stnname'];
    address = json['address'];
    contactno = json['contactno'];
    boardtime = json['boardtime'];
    td = json['td'];
    status = json['status'];
    stationid = json['stationid'];
    tripid = json['tripid'];
    sid = json['sid'];
    timedelay = json['timedelay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['venue'] = this.venue;
    data['glbid'] = this.glbid;
    data['stnname'] = this.stnname;
    data['address'] = this.address;
    data['contactno'] = this.contactno;
    data['boardtime'] = this.boardtime;
    data['td'] = this.td;
    data['status'] = this.status;
    data['stationid'] = this.stationid;
    data['tripid'] = this.tripid;
    data['sid'] = this.sid;
    data['timedelay'] = this.timedelay;
    return data;
  }
}

class Droppingpoint {
  List<DpDetails>? dpDetails;

  Droppingpoint({this.dpDetails});

  Droppingpoint.fromJson(Map<String, dynamic> json) {
    if (json['dpDetails'] != null) {
      dpDetails = <DpDetails>[];
      json['dpDetails'].forEach((v) {
        dpDetails!.add(new DpDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dpDetails != null) {
      data['dpDetails'] = this.dpDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DpDetails {
  String? id;
  String? venue;
  String? address;
  String? contactno;
  String? stationname;
  String? td;
  String? status;
  String? stationid;
  String? tripid;
  String? sid;
  String? glbid;
  String? bpoffice;
  String? pkupvan;
  String? droptime;
  String? timedelay;

  DpDetails(
      {this.id,
      this.venue,
      this.address,
      this.contactno,
      this.stationname,
      this.td,
      this.status,
      this.stationid,
      this.tripid,
      this.sid,
      this.glbid,
      this.bpoffice,
      this.pkupvan,
      this.droptime,
      this.timedelay});

  DpDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    venue = json['venue'];
    address = json['address'];
    contactno = json['contactno'];
    stationname = json['stationname'];
    td = json['td'];
    status = json['status'];
    stationid = json['stationid'];
    tripid = json['tripid'];
    sid = json['sid'];
    glbid = json['glbid'];
    bpoffice = json['bpoffice'];
    pkupvan = json['pkupvan'];
    droptime = json['droptime'];
    timedelay = json['timedelay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['venue'] = this.venue;
    data['address'] = this.address;
    data['contactno'] = this.contactno;
    data['stationname'] = this.stationname;
    data['td'] = this.td;
    data['status'] = this.status;
    data['stationid'] = this.stationid;
    data['tripid'] = this.tripid;
    data['sid'] = this.sid;
    data['glbid'] = this.glbid;
    data['bpoffice'] = this.bpoffice;
    data['pkupvan'] = this.pkupvan;
    data['droptime'] = this.droptime;
    data['timedelay'] = this.timedelay;
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