class StationListModel {
  final int? status;
  final String? message;
  final StationData? data;

  StationListModel({
    this.status,
    this.message,
    this.data,
  });

  factory StationListModel.fromJson(Map<String, dynamic> json) {
    return StationListModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? StationData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class StationData {
  final int? count;
  final List<City>? cities;
  final int? page;
  final bool? hasMore;

  StationData({
    this.count,
    this.cities,
    this.page,
    this.hasMore,
  });

  factory StationData.fromJson(Map<String, dynamic> json) {
    return StationData(
      count: json['count'],
      page: json['page'],
      hasMore: json['hasMore'],
      cities: (json['cities'] as List<dynamic>?)
          ?.map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'page': page,
      'hasMore': hasMore,
      'cities': cities?.map((e) => e.toJson()).toList(),
    };
  }
}

class City {
  final String? cityName;
  final List<String?>? cityIds;

  City({
    this.cityName,
    this.cityIds,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityName: json['cityName'],
      cityIds: (json['cityIds'] as List<dynamic>?)
          ?.map((e) => e?.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'cityIds': cityIds,
    };
  }
}
