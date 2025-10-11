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

  static Future<dynamic> postAPI(String apiName, var formData,{String? basurl2}) async {
    try {
      String callUrl =basurl2!=null?basurl2+apiName :ApiConst.baseUrl + apiName;

      
      String token = await Session().getToken();
    

      // if (token.isNotEmpty) {
      //   client.options.headers["authorization"] = "Bearer " + token;
      // } // todo:token get if present or required!
     
        
        // client.options.headers["devicetoken"]="";
        // client.options.headers["deviceType"]=Platform.isAndroid? "ANDROID":Platform.isIOS? "IOS":"WEB";
        if(basurl2!=null){
       client.options.headers["User-Agent"]="insomnia/11.2.0";
        client.options.headers["Authorization"]="Bearer $token";
        // client.options.headers["token"]= ApiConst.accessToken;
        }else{
       client.options.headers["User-Agent"]="insomnia/11.2.0";
        client.options.headers["token"]= ApiConst.accessToken;
        }
        // client.options.headers["Cookie"]="";
        // client.options.headers["PHPSESSID"]="qjmtid5a30e8sdgpcdu7h9a399";
      
      print("-------------------------");
      print("-------------------------");
      print("url:----- ${callUrl}");
      print("token:--- ${token}");
      print("header:----${client.options.headers.toString()}");
      print("data :--- ${formData.toString()}");

      var response = await client.post(callUrl, data: formData);
      // todo: response come when status is 200 only
      print("Response from the post Api ===> $response");
      return response;
    } on DioException catch (e) {
      //todo: other Exception code come here or message return
      if (e.response != null) {
        return e.response;
      } else {
        var err = {'"status"': 'false', '"message"': '"${e.message}"'};
        return err;
      }
    }
  }
}
