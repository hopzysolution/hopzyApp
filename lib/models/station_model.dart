class StationModel {
  Status? status;
  List<StationDetails>? stationDetails;

  StationModel({this.status, this.stationDetails});

  StationModel.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    if (json['stationDetails'] != null) {
      stationDetails = <StationDetails>[];
      json['stationDetails'].forEach((v) {
        stationDetails!.add(new StationDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.stationDetails != null) {
      data['stationDetails'] =
          this.stationDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Status {
  bool? success;
  String? message;
  int? code;

  Status({this.success, this.message, this.code});

  Status.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class StationDetails {
  String? stationId;
  String? station;
  String? state;

  StationDetails({this.stationId, this.station, this.state});

  StationDetails.fromJson(Map<String, dynamic> json) {
    stationId = json['stationId'];
    station = json['station'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stationId'] = this.stationId;
    data['station'] = this.station;
    data['state'] = this.state;
    return data;
  }
}