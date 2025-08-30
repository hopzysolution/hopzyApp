

// import 'package:dio/dio.dart';
// import 'package:ridebooking/repository/ApiConst.dart';
// import 'package:ridebooking/utils/session.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ridebooking/globels.dart' as globals;

// class ApiClient {
//   static final ApiClient _instance = ApiClient._internal();
//   factory ApiClient() => _instance;
//   ApiClient._internal();

//   final Dio dio = Dio(BaseOptions(baseUrl: "https://prodapi.hopzy.in/"));

//   void init() {
//     dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         final prefs = await SharedPreferences.getInstance();
//         final token = prefs.getString('accessToken');


//         if (token != null && options.path != ApiConst.refreshTokenApi) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }

//         return handler.next(options);
//       },
//       onError: (DioException error, handler) async {
//         if (error.response?.statusCode == 401 && !_isRefreshing) {
//           _isRefreshing = true;

//           try {
//             final prefs = await SharedPreferences.getInstance();
//             final refreshToken = prefs.getString('refreshToken');
//             if (refreshToken == null) return handler.next(error);

//             final newToken = await _refreshAccessToken(refreshToken);

//             if (newToken != null) {
//               await prefs.setString('accessToken', newToken);
//     await Session().setHopzyAccessToken(newToken);
              
//               error.requestOptions.headers['Authorization'] = 'Bearer $newToken';

//               final cloneReq = await dio.fetch(error.requestOptions);
//               return handler.resolve(cloneReq);
//             }
//           } catch (e) {
//             return handler.next(error);
//           } finally {
//             _isRefreshing = false;
//           }
//         }

//         return handler.next(error);
//       },
//     ));
//   }

//   bool _isRefreshing = false;

//   Future<String?> _refreshAccessToken(String refreshToken) async {
//     try {
//       final response = await dio.post(ApiConst.refreshTokenApi, data: {
//         'refreshToken': refreshToken,
//       });

//       return response.data['accessToken'];
//     } catch (e) {
//       print("Refresh failed: $e");
//       return null;
//     }
//   }

//   // Request OTP
//  Future<Response?> requestOtp(String email) async {
//   try {
//     print("Request Otp URL: ${dio.options.baseUrl}${ApiConst.requesOtp}");
//     print("Request Otp Headers: ${dio.options.headers}");
//     print("Request Otp Data: {'email': $email}");

//     final response = await dio.post(ApiConst.requesOtp, data: {'email': email});
    
//     print("Request Otp Success: ${response.data}");
//     return response;
//   } on DioException catch (e) {
//     print("Request Otp Failed:");
//     print("Status: ${e.response?.statusCode}");
//     print("Data: ${e.response?.data}");
//     print("Message: ${e.message}");
//     //  ToastMessage().showErrorToast(e.response?.data["message"]);
//     // Optional: Handle specific status
//     if (e.response?.statusCode == 500) {
//       // Maybe show dialog or return custom error
     
//     }

//     return null; // Let caller decide what to do
//   } catch (e) {
//     print("Unexpected error: $e");
//     return null;
//   }
// }


//   // Verify OTP
//  Future<Response?> verifyOtp(String email, String otp) async {
//   try {
//     final response = await dio.post(ApiConst.verifyOtp, data: {
//       'email': email,
//       'otp': otp,
//     });

//     final data = response.data;

//     print("Verify OTP Success: $data");

//     final prefs = await SharedPreferences.getInstance();
//     await Session().setHopzyAccessToken(data["data"]["accessToken"]);
//     await prefs.setString('accessToken', data["data"]["accessToken"]);
//     await prefs.setString('refreshToken', data["data"]["refreshToken"]);

//     return response;
//   } on DioException catch (e) {
//     print("Verify OTP Failed: ${e.response?.statusCode} - ${e.response?.data}");
//     return null;
//   }
// }



// }


import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ridebooking/repository/ApiConst.dart';
import 'package:ridebooking/utils/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ridebooking/globels.dart' as globals;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final Dio dio = Dio(BaseOptions(
    baseUrl: "https://prodapi.hopzy.in/",
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  ));

  bool _isRefreshing = false;
  final List<RequestOptions> _failedQueue = [];
  Timer? _refreshTimer;
  
  // Token refresh interval (10 minutes)
  static const Duration _refreshInterval = Duration(minutes: 10);

  void init() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('accessToken');

          if (token != null && options.path != ApiConst.refreshTokenApi) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          _logRequest(options);
          return handler.next(options);
        } catch (e) {
          return handler.reject(DioException(
            requestOptions: options,
            error: 'Failed to prepare request: $e',
          ));
        }
      },
      onResponse: (response, handler) {
        _logResponse(response);
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        _logError(error);
        
        if (error.response?.statusCode == 401 && 
            error.requestOptions.path != ApiConst.refreshTokenApi) {
          
          if (!_isRefreshing) {
            _isRefreshing = true;
            
            try {
              final success = await _handleTokenRefresh();
              
              if (success) {
                // Retry original request
                final cloneReq = await _retryRequest(error.requestOptions);
                
                // Process queued requests
                await _processQueuedRequests();
                
                return handler.resolve(cloneReq);
              } else {
                await _handleLogout();
                _rejectQueuedRequests(error);
              }
            } catch (e) {
              await _handleLogout();
              _rejectQueuedRequests(error);
            } finally {
              _isRefreshing = false;
            }
          } else {
            // Queue the request to retry after token refresh
            _failedQueue.add(error.requestOptions);
            return; // Don't call handler.next() yet
          }
        }

        return handler.next(error);
      },
    ));

    // Start periodic token refresh
    _startPeriodicTokenRefresh();
  }

  /// Start automatic token refresh every 10 minutes
  void _startPeriodicTokenRefresh() {
    _refreshTimer?.cancel(); // Cancel existing timer if any
    
    _refreshTimer = Timer.periodic(_refreshInterval, (timer) async {
      await _performPeriodicRefresh();
    });
    
    print("🔄 Periodic token refresh started (every ${_refreshInterval.inMinutes} minutes)");
  }

  /// Stop the periodic token refresh
  void stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    print("⏹️ Periodic token refresh stopped");
  }

  /// Perform the actual periodic refresh
  Future<void> _performPeriodicRefresh() async {
    if (_isRefreshing) {
      print("⏳ Token refresh already in progress, skipping periodic refresh");
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final refreshToken = prefs.getString('refreshToken');

      // Only refresh if we have both tokens
      if (accessToken == null || refreshToken == null) {
        print("🚫 No tokens found, skipping periodic refresh");
        return;
      }

      print("🔄 Starting periodic token refresh...");
      _isRefreshing = true;

      final newToken = await _refreshAccessToken(refreshToken);

      if (newToken != null) {
        await _saveTokens(newToken);
        print("✅ Periodic token refresh successful");
      } else {
        print("❌ Periodic token refresh failed");
        // Don't logout on periodic refresh failure, just log the error
        // The user might be offline or there might be temporary server issues
      }
    } catch (e) {
      print("❌ Error during periodic token refresh: $e");
      // Don't logout on periodic refresh failure
    } finally {
      _isRefreshing = false;
    }
  }

  /// Manually refresh token (can be called from UI)
  Future<bool> manualTokenRefresh() async {
    if (_isRefreshing) {
      print("Token refresh already in progress");
      return false;
    }

    try {
      _isRefreshing = true;
      print("🔄 Manual token refresh initiated...");
      
      final success = await _handleTokenRefresh();
      
      if (success) {
        print("✅ Manual token refresh successful");
        // Reset the periodic timer
        _startPeriodicTokenRefresh();
        return true;
      } else {
        print("❌ Manual token refresh failed");
        return false;
      }
    } finally {
      _isRefreshing = false;
    }
  }

  Future<bool> _handleTokenRefresh() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');
      
      if (refreshToken == null) {
        return false;
      }

      final newToken = await _refreshAccessToken(refreshToken);

      if (newToken != null) {
        await _saveTokens(newToken);
        return true;
      }
      
      return false;
    } catch (e) {
      print("Token refresh error: $e");
      return false;
    }
  }

  Future<String?> _refreshAccessToken(String refreshToken) async {
    try {
      final response = await dio.post(
        ApiConst.refreshTokenApi, 
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Authorization': null}, // Remove auth header for refresh
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Some APIs return new refresh token as well
        if (data['refreshToken'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('refreshToken', data['refreshToken']);
        }
        
        return data['accessToken'];
      }
      
      return null;
    } catch (e) {
      print("Refresh token failed: $e");
      return null;
    }
  }

  Future<void> _saveTokens(String accessToken, [String? refreshToken]) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('accessToken', accessToken);
    await Session().setToken(accessToken);
    await Session().setHopzyAccessToken(accessToken);
    
    if (refreshToken != null) {
      await prefs.setString('refreshToken', refreshToken);
    }

    // Store the refresh timestamp for debugging
    await prefs.setInt('lastTokenRefresh', DateTime.now().millisecondsSinceEpoch);
  }

  /// Get time until next refresh
  Duration? getTimeUntilNextRefresh() {
    if (_refreshTimer == null || !_refreshTimer!.isActive) return null;
    
    // This is an approximation since Timer.periodic doesn't expose remaining time
    return _refreshInterval;
  }

  /// Check if token refresh is currently active
  bool get isRefreshing => _isRefreshing;

  /// Get last refresh time
  Future<DateTime?> getLastRefreshTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('lastTokenRefresh');
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    
    if (token != null) {
      requestOptions.headers['Authorization'] = 'Bearer $token';
    }
    
    return await dio.fetch(requestOptions);
  }

  Future<void> _processQueuedRequests() async {
    final requests = List<RequestOptions>.from(_failedQueue);
    _failedQueue.clear();
    
    for (final request in requests) {
      try {
        await _retryRequest(request);
      } catch (e) {
        print("Failed to retry queued request: $e");
      }
    }
  }

  void _rejectQueuedRequests(DioException originalError) {
    _failedQueue.clear();
  }

  Future<void> _handleLogout() async {
    try {
      // Stop periodic refresh on logout
      stopPeriodicRefresh();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      await prefs.remove('lastTokenRefresh');
      // await Session().clearSession();
      
      print("🚪 User logged out, tokens cleared");
      // Navigate to login screen
      // Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      print("Logout error: $e");
    }
  }

  /// Call this when user logs in successfully
  Future<void> onLoginSuccess(String accessToken, String refreshToken) async {
    await _saveTokens(accessToken, refreshToken);
    // await Session().setToken()
    _startPeriodicTokenRefresh(); // Start the periodic refresh
  }

  /// Call this when app is disposed or user logs out
  void dispose() {
    stopPeriodicRefresh();
    dio.close();
  }

  // Conditional logging
  void _logRequest(RequestOptions options) {
    // if (globals.isDebugMode) {
      print("🚀 REQUEST: ${options.method} ${options.uri}");
      print("Headers: ${options.headers}");
      if (options.data != null) print("Data: ${options.data}");
    // }
  }

  void _logResponse(Response response) {
    // if (globals.isDebugMode) {
      print("✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}");
      print("Data: ${response.data}");
    // }
  }

  void _logError(DioException error) {
    // if (globals.isDebugMode) {
      print("❌ ERROR: ${error.response?.statusCode} ${error.requestOptions.uri}");
      print("Message: ${error.message}");
      print("Data: ${error.response?.data}");
    // }
  }

  // Your existing API methods
  Future<ApiResponse<T>> requestOtp<T>(String phone) async {
    try {
      phone = phone.contains("+91") ? phone : "+91$phone";
      final response = await dio.post(
        ApiConst.requesOtp, 
        data: {'phone': phone},
      );
      print("Api response =response.data;// =======>>>>${response.data}");
      
      return ApiResponse.success(response.data);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error("Unexpected error: $e");
    }
  }

  Future<ApiResponse<T>> registerUser<T>(String fName,String lName,String phone) async {
    try {
      phone = phone.contains("+91") ? phone : "+91$phone";
      final response = await dio.post(
        ApiConst.registerUser, 
        data: {"firstName": fName, "lastName": lName, "phone": phone},
      );
      print("Api response =register user// =======>>>>${response.data}");
      
      return ApiResponse.success(response.data);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error("Unexpected error: $e");
    }
  }

  Future<ApiResponse<T>> verifyOtp<T>(String phone, String otp) async {
    try {
      phone = phone.contains("+91") ? phone : "+91$phone";
      final response = await dio.post(ApiConst.verifyOtp, data: {
        'phone': phone,
        'otp': otp,
      });

      final data = response.data;
      
      // Save tokens and start periodic refresh
      if (data["data"]["accessToken"] != null) {
        await onLoginSuccess(
          data["data"]["accessToken"],
          data["data"]["refreshToken"],
        );
      }

      return ApiResponse.success(data);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error("Unexpected error: $e");
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "Connection timeout. Please check your internet connection.";
      case DioExceptionType.connectionError:
        return "No internet connection. Please check your network.";
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Server error occurred';
        return "Server error ($statusCode): $message";
      default:
        return e.response?.data?['message'] ?? "An error occurred";
    }
  }
}

// Response wrapper class for better error handling
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResponse.success(this.data) : error = null, isSuccess = true;
  ApiResponse.error(this.error) : data = null, isSuccess = false;
}
