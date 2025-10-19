import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ridebooking/utils/session.dart';
import 'ApiConst.dart';
import 'package:http_parser/http_parser.dart';

class ApiRepository {
  static Dio client = Dio();

  static Future<dynamic> getAPI(String apiName,{String? basurl2}) async {
    try {
     
          String callingUrl =basurl2!=null?basurl2+apiName :ApiConst.baseUrl + apiName;

      String token = await Session().getToken();

        if(basurl2 != null){
          print("in header Authorization ---------->>>>>>");
        client.options.headers["Authorization"]="Bearer $token";
        }
        else{
          
        // client.options.headers["User-Agent"]="insomnia/11.2.0";
        client.options.headers["token"]=  ApiConst.accessToken;
        client.options.headers["Cookie"]="";
        client.options.headers["PHPSESSID"]="qjmtid5a30e8sdgpcdu7h9a399";
        }
        
      
      print("Calling url is --->>> : ${callingUrl}");
      print("token of ------>>>>: ${token != null?token:ApiConst.accessToken}");
      print("header of ----->>>: ${client.options.headers.toString()}");

      var response = await client.get(callingUrl);
      // todo: response come when status is 200 only
      print("Response from the get Api ===> $response");
      return response;
    } on DioException catch (e) {
      print("Error ====>    " + e.response.toString() + e.error.toString());
      //todo: other Exception code come here or message return
      return e.response;
    }
  }

  static Future<dynamic> fileUpload(File file) async {
    try {
      String fileName = file.path.split('/').last;
      final data = FormData.fromMap({
        'files': [
          await MultipartFile.fromFile(file.uri.path,
              filename: fileName, contentType: MediaType('image', '*')),
        ],
      });
      String token = await Session().getToken();

      if (token.isNotEmpty) {
        client.options.headers["authorization"] = "Bearer " + token;
      }

      String callingUrl = ApiConst.baseUrl ;
      var response = await client.post(callingUrl, data: data);

      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response;
      } else {
        var err = {'"status"': 'false', '"message"': '"${e.message}"'};
        return err;
      }
    }
  }

  static Future<dynamic> putAPI(String apiName, var formData) async {
    try {
      String callUrl = ApiConst.baseUrl + apiName;
      String token = await Session().getToken();

      print("-------------------------");
      print("url:----- ${callUrl}");
      print("token:--- ${token}");
      print("data :--- ${formData.toString()}");

      if (token.isNotEmpty) {
        client.options.headers["authorization"] = "Bearer " + token;
      } // todo:token get if present or required!
      var response = await client.put(callUrl, data: formData);
      // todo: response come when status is 200 only
      return response;
    } on DioException catch (e) {
      print(e.response);
      return e.response;
    }
  }

  static Future<dynamic> deleteAPI(String apiName, {Object? data}) async {
    try {
      String callUrl = ApiConst.baseUrl + apiName;
      String token = await Session().getToken();

      client.options.headers["authorization"] = "Bearer " + token;
      print("url: ${callUrl}");
      // print("data : ${data.toString()}");
      print("Tag Delete call---------------------${data}");
      var response = data != null
          ? await client.delete(callUrl, data: data)
          : await client.delete(callUrl);
      print("Tag Deleted---------------------");
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

 static Future<dynamic> postAPI(String apiName, var formData, {String? basurl2}) async {
  try {
    // ✅ Build URL
    String callUrl = basurl2 != null ? basurl2 + apiName : ApiConst.baseUrl + apiName;

    // ✅ Get token
    String token = await Session().getToken();

    // ✅ Set headers based on base URL
    client.options.headers["User-Agent"] = "insomnia/11.2.0";
    if (basurl2 != null) {
      client.options.headers["Authorization"] = "Bearer $token";
    } else {
      client.options.headers["token"] = ApiConst.accessToken;
    }

    // ✅ Debug logs
    print("------------------------------------------------------------");
    print("📡 POST API CALL");
    print("➡️ URL: $callUrl");
    print("🔑 Token: $token");
    print("🧾 Headers: ${client.options.headers}");
    print("📦 Data: $formData");
    print("------------------------------------------------------------");

    // ✅ API Call
    final response = await client.post(callUrl, data: formData);

    // ✅ Only log 200/201 as success
    print("✅ Response (${response.statusCode}): ${response.data}");

    return response;
  } on DioException catch (e) {
    print("❌ DioException occurred");

    // ✅ Check if we got a response from server
    if (e.response != null) {
      print("🔴 Server responded with status: ${e.response?.statusCode}");
      print("🧩 Response data: ${e.response?.data}");

      // Handle different status codes gracefully
      switch (e.response?.statusCode) {
        case 400:
          return {"status": false, "message": e.message};
        case 401:
          return {"status": false, "message": e.message};
        case 403:
          return {"status": false, "message": e.message};
        case 404:
          return {"status": false, "message": e.message};
        case 408:
          return {"status": false, "message": e.message};
        case 500:
          return {"status": false, "message": e.message};
        case 502:
        case 503:
        case 504:
          return {"status": false, "message": e.message};
        default:
          return {
            "status": false,
            "message": "Unexpected server error (${e.response?.statusCode}).",
            "data": e.response?.data
          };
      }
    } else {
      // ✅ No server response (network, timeout, etc.)
      if (e.type == DioExceptionType.connectionTimeout) {
        return {"status": false, "message": "Connection timeout — check your internet connection."};
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return {"status": false, "message": "Response timeout — please try again later."};
      } else if (e.type == DioExceptionType.badCertificate) {
        return {"status": false, "message": "SSL certificate error — connection not secure."};
      } else if (e.type == DioExceptionType.connectionError) {
        return {"status": false, "message": "Network error — please check your connection."};
      } else if (e.type == DioExceptionType.cancel) {
        return {"status": false, "message": "Request was cancelled."};
      } else {
        return {"status": false, "message": e.message ?? "Unexpected error occurred."};
      }
    }
  } catch (err, stacktrace) {
    // ✅ Catch any other unexpected exceptions
    print("⚠️ Unexpected Exception: $err");
    print("🪵 Stacktrace: $stacktrace");
    return {"status": false, "message": "Something went wrong. Please try again later."};
  }
}

}
