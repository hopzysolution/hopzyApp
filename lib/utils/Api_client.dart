import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ridebooking/utils/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final Dio dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:8000/api"));

  void init() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken');

        if (token != null && options.path != "/auth/refresh-token") {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;

          try {
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString('refreshToken');
            if (refreshToken == null) return handler.next(error);

            final newToken = await _refreshAccessToken(refreshToken);

            if (newToken != null) {
              await prefs.setString('accessToken', newToken);
              error.requestOptions.headers['Authorization'] = 'Bearer $newToken';

              final cloneReq = await dio.fetch(error.requestOptions);
              return handler.resolve(cloneReq);
            }
          } catch (e) {
            return handler.next(error);
          } finally {
            _isRefreshing = false;
          }
        }

        return handler.next(error);
      },
    ));
  }

  bool _isRefreshing = false;

  Future<String?> _refreshAccessToken(String refreshToken) async {
    try {
      final response = await dio.post('/auth/refresh-token', data: {
        'refreshToken': refreshToken,
      });

      return response.data['accessToken'];
    } catch (e) {
      print("Refresh failed: $e");
      return null;
    }
  }

  // Request OTP
  Future<Response> requestOtp(String email) {
    return dio.post('/auth/request-otp', data: {'email': email});
  }

  // Verify OTP
  Future<Response> verifyOtp(String email, String otp) async {
    final response = await dio.post('/auth/verify-otp', data: {
      'email': email,
      'otp': otp,
    });
    // if(response.toString().contains("status")){
      Map<String, dynamic> parsed = json.decode(response.toString());
      print("---===>>${parsed["data"]["accessToken"]}-----${parsed.toString()}-------->>>>${response.toString()}");

    final prefs = await SharedPreferences.getInstance();

    await Session().setToken(parsed["data"]["accessToken"]);

    await prefs.setString('accessToken', parsed["data"]["accessToken"]);
    await prefs.setString('refreshToken', parsed["data"]["refreshToken"]);
    
    

    return response;
  }
}
