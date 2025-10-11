class Availabletripdata {
  int? status;
  String? message;
  Data? data;

  Availabletripdata({this.status, this.message, this.data});

  Availabletripdata.fromJson(Map<String, dynamic> json) {
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
  int? totalTrips;
  List<Trips>? trips;

  Data({this.totalTrips, this.trips});

  Data.fromJson(Map<String, dynamic> json) {
    totalTrips = json['totalTrips'];
    if (json['trips'] != null) {
      trips = <Trips>[];
      json['trips'].forEach((v) {
        trips!.add(new Trips.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalTrips'] = this.totalTrips;
    if (this.trips != null) {
      data['trips'] = this.trips!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trips {
  String? provider;
  String? operatorid;
  String? operatorname;
  String? srcId;
  String? dstId;
  String? src;
  String? dst;
  String? routeid;
  String? tripDate;
  String? travelTime;
  String? tripid;
  String? subtripid;
  String? scheduleCode;
  String? bustype;
  String? totalseats;
  String? availseats;
  String? fare;
  ServiceTax? servicetax;
  String? seattype;
  String? deptime;
  String? arrtime;
  String? vehiclenumber;
  String? amenities;
  String? schnote;
  String? blockingtype;
  Boardingpoint? boardingpoint;
  Droppingpoint? droppingpoint;
  String? cancellationrefrncetime;
  Cancellationpolicy? cancellationpolicy;
  String? traveltime;

  Trips(
      {this.provider,
      this.operatorid,
      this.operatorname,
      this.srcId,
      this.dstId,
      this.src,
      this.dst,
      this.routeid,
      this.tripDate,
      this.travelTime,
      this.tripid,
      this.subtripid,
      this.scheduleCode,
      this.bustype,
      this.totalseats,
      this.availseats,
      this.fare,
      this.servicetax,
      this.seattype,
      this.deptime,
      this.arrtime,
      this.vehiclenumber,
      this.amenities,
      this.schnote,
      this.blockingtype,
      this.boardingpoint,
      this.droppingpoint,
      this.cancellationrefrncetime,
      this.cancellationpolicy,
      this.traveltime});

  Trips.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    operatorid = json['operatorid'].toString();
    operatorname = json['operatorname'];
    srcId = json['srcId'].toString();
    dstId = json['dstId'].toString();
    src = json['src'];
    dst = json['dst'];
    routeid = json['routeid'].toString();
    tripDate = json['tripDate'];
    travelTime = json['travelTime'];
    tripid = json['tripid'].toString();
    subtripid = json['subtripid'];
    scheduleCode = json['scheduleCode'].toString();
    bustype = json['bustype'];
    totalseats = json['totalseats'].toString();
    availseats = json['availseats'].toString();
    fare = json['fare'].toString();
    
        final st = json['servicetax'];
    if (st != null) {
      if (st is int) {
        servicetax = ServiceTax(value: st.toDouble());
      } else if (st is Map<String, dynamic>) {
        servicetax = ServiceTax.fromJson(st);
      }
    }
 
    

    seattype = json['seattype'];
    deptime = json['deptime'];
    arrtime = json['arrtime'];
    vehiclenumber = json['vehiclenumber'];
    amenities = json['amenities'];
    schnote = json['schnote'];
    blockingtype = json['blockingtype'];
    boardingpoint = json['boardingpoint'] != null
        ? new Boardingpoint.fromJson(json['boardingpoint'])
        : null;
    droppingpoint = json['droppingpoint'] != null
        ? new Droppingpoint.fromJson(json['droppingpoint'])
        : null;
    cancellationrefrncetime = json['cancellationrefrncetime'].toString();
    cancellationpolicy = json['cancellationpolicy'] != null
        ? new Cancellationpolicy.fromJson(json['cancellationpolicy'])
        : null;
    traveltime = json['traveltime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provider'] = this.provider;
    data['operatorid'] = this.operatorid;
    data['operatorname'] = this.operatorname;
    data['srcId'] = this.srcId;
    data['dstId'] = this.dstId;
    data['src'] = this.src;
    data['dst'] = this.dst;
    data['routeid'] = this.routeid;
    data['tripDate'] = this.tripDate;
    data['travelTime'] = this.travelTime;
    data['tripid'] = this.tripid;
    data['subtripid'] = this.subtripid;
    data['scheduleCode'] = this.scheduleCode;
    data['bustype'] = this.bustype;
    data['totalseats'] = this.totalseats;
    data['availseats'] = this.availseats;
    data['fare'] = this.fare;
     if (servicetax != null) {
      data['servicetax'] = servicetax!.toJson();
    }
    data['seattype'] = this.seattype;
    data['deptime'] = this.deptime;
    data['arrtime'] = this.arrtime;
    data['vehiclenumber'] = this.vehiclenumber;
    data['amenities'] = this.amenities;
    data['schnote'] = this.schnote;
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
    data['traveltime'] = this.traveltime;
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
  String? stnname;
  String? address;
  String? contactno;
  String? boardtime;

  BpDetails(
      {this.id,
      this.venue,
      this.stnname,
      this.address,
      this.contactno,
      this.boardtime});

  BpDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    venue = json['venue'];
    stnname = json['stnname'];
    address = json['address'];
    contactno = json['contactno'];
    boardtime = json['boardtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['venue'] = this.venue;
    data['stnname'] = this.stnname;
    data['address'] = this.address;
    data['contactno'] = this.contactno;
    data['boardtime'] = this.boardtime;
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
  String? stnname;
  String? address;
  String? contactno;
  String? droptime;

  DpDetails(
      {this.id,
      this.venue,
      this.stnname,
      this.address,
      this.contactno,
      this.droptime});

  DpDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    venue = json['venue'];
    stnname = json['stnname'];
    address = json['address'];
    contactno = json['contactno'];
    droptime = json['droptime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['venue'] = this.venue;
    data['stnname'] = this.stnname;
    data['address'] = this.address;
    data['contactno'] = this.contactno;
    data['droptime'] = this.droptime;
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

class ServiceTax {
  double? value; // simple case when API sends "0"
  double? cgstValue;
  double? sgstValue;
  double? ugstValue;
  double? igstValue;
  String? tradeName;
  String? gstin;

  ServiceTax({
    this.value,
    this.cgstValue,
    this.sgstValue,
    this.ugstValue,
    this.igstValue,
    this.tradeName,
    this.gstin,
  });

  ServiceTax.fromJson(Map<String, dynamic> json) {
    cgstValue = (json['cgstValue'] as num?)?.toDouble();
    sgstValue = (json['sgstValue'] as num?)?.toDouble();
    ugstValue = (json['ugstValue'] as num?)?.toDouble();
    igstValue = (json['igstValue'] as num?)?.toDouble();
    tradeName = json['tradeName'];
    gstin = json['gstin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (value != null) {
      data['value'] = value;
    } else {
      data['cgstValue'] = cgstValue;
      data['sgstValue'] = sgstValue;
      data['ugstValue'] = ugstValue;
      data['igstValue'] = igstValue;
      data['tradeName'] = tradeName;
      data['gstin'] = gstin;
    }
    return data;
  }
}