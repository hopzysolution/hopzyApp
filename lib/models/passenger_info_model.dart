class PassengerInfoModel {
  String? name;
  String? gender;
  String? seatNo;
  String? age;
  String? fare;

  PassengerInfoModel(
      {this.name, this.gender, this.seatNo, this.age, this.fare});

  PassengerInfoModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    gender = json['gender'];
    seatNo = json['seatNo'];
    age = json['age'];
    fare = json['fare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['gender'] = this.gender;
    data['seatNo'] = this.seatNo;
    data['age'] = this.age;
    data['fare'] = this.fare;
    return data;
  }
}