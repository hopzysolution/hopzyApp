class GstDataModel {
  GstDetails? gstDetails;

  GstDataModel({this.gstDetails});

  GstDataModel.fromJson(Map<String, dynamic> json) {
    gstDetails = json['gstDetails'] != null
        ? new GstDetails.fromJson(json['gstDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gstDetails != null) {
      data['gstDetails'] = this.gstDetails!.toJson();
    }
    return data;
  }
}

class GstDetails {
  String? gstNumber;
  String? businessName;
  String? businessAddress;
  String? businessEmail;

  GstDetails(
      {this.gstNumber,
      this.businessName,
      this.businessAddress,
      this.businessEmail});

  GstDetails.fromJson(Map<String, dynamic> json) {
    gstNumber = json['gstNumber'];
    businessName = json['businessName'];
    businessAddress = json['businessAddress'];
    businessEmail = json['businessEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gstNumber'] = this.gstNumber;
    data['businessName'] = this.businessName;
    data['businessAddress'] = this.businessAddress;
    data['businessEmail'] = this.businessEmail;
    return data;
  }
}