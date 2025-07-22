// class ApiResponse<T> {
//   bool status;
//   String message;
//   T? data;

//   ApiResponse(
//       {required this.status, required this.message,  this.data});

//   factory ApiResponse.fromJson(
//       Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
//     return ApiResponse<T>(
//       status: json["statusCode"],
//       message: json["message"],
//       data: create(json["data"]),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "status": this.status,
//         "message": this.message,
//         "data": this.data!.toString(),
//       };
// }

// abstract class Serializable {
//   Map<String, dynamic> toJson();
// }

class ApiResponse<T> {
  final Status status;
  final T? data;

  ApiResponse({required this.status,this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json,Function(Map<String, dynamic>) create) {
    return ApiResponse<T>(
      status: Status.fromJson(json['status']),
      data: create(json["data"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toJson(),
      "data": this.data!.toString(),
    };
  }
}

class Status {
  final bool success;
  final String message;
  final int code;

  Status({
    required this.success,
    required this.message,
    required this.code,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'code': code,
    };
  }
}
