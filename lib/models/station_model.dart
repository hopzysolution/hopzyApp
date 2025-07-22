class StationModel {
  List<StationDetails>? stationDetails;

  StationModel({this.stationDetails});

  StationModel.fromJson(Map<String, dynamic> json) {
    if (json['stationDetails'] != null) {
      stationDetails = <StationDetails>[];
      json['stationDetails'].forEach((v) {
        stationDetails!.add(new StationDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stationDetails != null) {
      data['stationDetails'] =
          this.stationDetails!.map((v) => v.toJson()).toList();
    }
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