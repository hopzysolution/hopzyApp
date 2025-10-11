import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:ridebooking/bloc/booking_bloc/booking_bloc.dart';
import 'package:ridebooking/models/available_trip_data.dart';
import 'package:ridebooking/models/create_order_data_model.dart';
import 'package:ridebooking/models/seat_modell.dart';
import 'package:ridebooking/models/passenger_model.dart';

class PayUPaymentScreen extends StatefulWidget {
  final BookingBloc? forPayment;
  final CreateOrderDataModel? createOrderDataModel;
  final String? bpoint;
  final Set<SeatModell>? selectedSeats;
  final List<Passenger>? selectedPassenger;
  final BpDetails? selectedBoardingPointDetails;
  final DpDetails? selectedDroppingPointDetails;
  final VoidCallback? onPayuPaymentSuccess;

  const PayUPaymentScreen({
    super.key,
    this.forPayment,
    this.createOrderDataModel,
    this.bpoint,
    this.selectedSeats,
    this.selectedPassenger,
    this.selectedBoardingPointDetails,
    this.selectedDroppingPointDetails,
    this.onPayuPaymentSuccess
  });

  @override
  State<PayUPaymentScreen> createState() => _PayUPaymentScreenState();
}

class _PayUPaymentScreenState extends State<PayUPaymentScreen>
    implements PayUCheckoutProProtocol {
  late PayUCheckoutProFlutter _checkoutPro;
  bool _isPaymentStarted = false;
  bool _isProcessingCallback = false;
  final Map<String, String> _hashCache = {};

  @override
  void initState() {
    super.initState();
    _checkoutPro = PayUCheckoutProFlutter(this);

    // Add delay to allow WebView to initialize properly
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted && _validatePaymentData()) {
        // Wait a bit for the UI to settle
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          _startPayment();
        }
      } else {
        _showSnack("Invalid payment data");
        Navigator.of(context).pop();
      }
    });
  }

  bool _validatePaymentData() {
    final payUData = widget.createOrderDataModel?.data?.payUData;
    
    if (payUData == null) {
      debugPrint("PayU data is null");
      return false;
    }

    final requiredFields = {
      'key': payUData.key,
      'amount': payUData.amount,
      'txnid': payUData.txnid,
      'productinfo': payUData.productinfo,
      'firstname': payUData.firstname,
      'email': payUData.email,
      'phone': payUData.phone,
      'surl': payUData.surl,
      'furl': payUData.furl,
      'hash': payUData.hash,
    };

    for (String fieldName in requiredFields.keys) {
      if (requiredFields[fieldName] == null || 
          requiredFields[fieldName]!.isEmpty) {
        debugPrint("Missing required field: $fieldName");
        return false;
      }
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(payUData.email!)) {
      debugPrint("Invalid email format: ${payUData.email}");
      return false;
    }

    if (payUData.phone!.length < 10) {
      debugPrint("Invalid phone format: ${payUData.phone}");
      return false;
    }

    try {
      double amount = double.parse(payUData.amount!);
      if (amount <= 0) {
        debugPrint("Invalid amount: ${payUData.amount}");
        return false;
      }
    } catch (e) {
      debugPrint("Amount parsing error: ${payUData.amount}");
      return false;
    }

    debugPrint("All payment data validated successfully");
    return true;
  }

  @override
  generateHash(Map response) async {
    try {
      final String? hashName = response[PayUHashConstantsKeys.hashName]?.toString();
      final String? hashString = response[PayUHashConstantsKeys.hashString]?.toString();
      final String? hashType = response[PayUHashConstantsKeys.hashType]?.toString();
      final String? postSalt = response[PayUHashConstantsKeys.postSalt]?.toString();

      debugPrint("=== Hash Request ===");
      debugPrint("Hash Name: $hashName");
      debugPrint("Hash String: $hashString");
      debugPrint("Hash Type: $hashType");
      debugPrint("Post Salt: $postSalt");

      if (hashName == null || hashName.isEmpty) {
        debugPrint('❌ Missing hashName');
        _checkoutPro.hashGenerated(hash: {});
        return;
      }

      // Check cache first
      if (_hashCache.containsKey(hashName)) {
        debugPrint("✅ Using cached hash for: $hashName");
        _checkoutPro.hashGenerated(hash: {hashName: _hashCache[hashName]!});
        return;
      }

      // Check for static hashes
      final hashes = widget.createOrderDataModel?.data?.hashes;
      
      if (hashes != null) {
        final Map<String, String> staticHashMap = {
          "payment": hashes.payment ?? '',
          "vas_for_mobile_sdk": hashes.vasForMobileSdk ?? '',
          "payment_related_details_for_mobile_sdk": hashes.paymentRelatedDetailsForMobileSdk ?? '',
        };

        if (staticHashMap.containsKey(hashName) && staticHashMap[hashName]!.isNotEmpty) {
          debugPrint("✅ Using static hash for: $hashName");
          final hash = staticHashMap[hashName]!;
          _hashCache[hashName] = hash;
          _checkoutPro.hashGenerated(hash: {hashName: hash});
          return;
        }
      }

      // Generate dynamic hash from backend
      if (hashString == null || hashString.isEmpty) {
        debugPrint('❌ Missing hashString for dynamic hash');
        _checkoutPro.hashGenerated(hash: {});
        return;
      }

      debugPrint("🔄 Calling backend for dynamic hash: $hashName");
      
      // Run hash generation in isolate to avoid blocking main thread
      final generatedHash = await _generateHashFromBackend(
        hashName: hashName,
        hashString: hashString,
        hashType: hashType,
        postSalt: postSalt,
      );

      if (generatedHash.isEmpty) {
        debugPrint("❌ Failed to generate hash from backend");
        _checkoutPro.hashGenerated(hash: {});
        return;
      }

      debugPrint("✅ Hash generated successfully: ${generatedHash.substring(0, 20)}...");
      _hashCache[hashName] = generatedHash;
      _checkoutPro.hashGenerated(hash: {hashName: generatedHash});
      
    } catch (e, st) {
      debugPrint("❌ generateHash error: $e");
      debugPrint("Stack trace: $st");
      _checkoutPro.hashGenerated(hash: {});
    }
  }

  Future<String> _generateHashFromBackend({
    required String hashName,
    required String hashString,
    String? hashType,
    String? postSalt,
  }) async {
    debugPrint("🌐 Backend call - Hash: $hashName");
    
    try {
      final requestBody = {
        'hashName': hashName,
        'hashString': hashString.trim(),
        if (hashType != null && hashType.isNotEmpty) 'hashType': hashType,
        if (postSalt != null && postSalt.isNotEmpty) 'postSalt': postSalt,
      };
      
      debugPrint("📤 Request: ${jsonEncode(requestBody)}");
      
      final response = await _makeRequestWithRetry(
        Uri.parse('https://stagingapi.hopzy.in/api/public/generate-hash'),
        requestBody,
        maxRetries: 2,
      );

      debugPrint("📥 Response status: ${response.statusCode}");
      debugPrint("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true && data['hash'] != null) {
          final hash = data['hash'].toString();
          
          if (hash.isEmpty) {
            debugPrint("❌ Backend returned empty hash");
            return '';
          }
          
          debugPrint("✅ Valid hash received from backend");
          return hash;
        } else {
          debugPrint("❌ Backend response missing success/hash fields");
          return '';
        }
      } else {
        debugPrint("❌ Backend error: ${response.statusCode} - ${response.body}");
        return '';
      }
    } on TimeoutException catch (e) {
      debugPrint("⏱️ Timeout: $e");
      return '';
    } on SocketException catch (e) {
      debugPrint("🌐 Network error: $e");
      return '';
    } catch (e, st) {
      debugPrint("❌ Error: $e");
      debugPrint("Stack: $st");
      return '';
    }
  }

  Future<http.Response> _makeRequestWithRetry(
    Uri url,
    Map<String, dynamic> body, {
    int maxRetries = 2,
  }) async {
    int attempt = 0;
    
    while (attempt < maxRetries) {
      try {
        debugPrint("🔄 Attempt ${attempt + 1} of $maxRetries");
        
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(body),
        ).timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeoutException('Request timeout after 20 seconds');
          },
        );
        
        return response;
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          rethrow;
        }
        debugPrint("⚠️ Attempt $attempt failed, retrying...");
        await Future.delayed(Duration(seconds: attempt));
      }
    }
    
    throw Exception('Max retries exceeded');
  }

  void _showSnack(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
            backgroundColor: message.toLowerCase().contains('success') 
                ? Colors.green 
                : Colors.red,
          ),
        );
      }
    });
  }

  @override
  onPaymentSuccess(dynamic response) async {
    if (_isProcessingCallback) {
      debugPrint("⚠️ Already processing callback, ignoring duplicate");
      return;
    }
    
    _isProcessingCallback = true;
    
    debugPrint("✅ Payment Success: $response");
    
    String? paymentId;
    String? txnId;
    
    if (response is Map) {
      paymentId = response['payuMoneyId']?.toString();
      txnId = response['txnid']?.toString();
      
      debugPrint("Payment ID: $paymentId");
      debugPrint("Transaction ID: $txnId");
    }

    _showSnack("Payment Successful!");
    
    // Wait for UI to update
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      // Call the callback first
      if (widget.onPayuPaymentSuccess != null) {
        debugPrint("🎉 Calling onPayuPaymentSuccess callback");
        try {
          widget.onPayuPaymentSuccess!();
        } catch (e) {
          debugPrint("❌ Error in callback: $e");
        }
      }
      
      // Then pop with success result
      Navigator.of(context).pop({
        'status': 'success',
        'response': response,
        'paymentId': paymentId,
        'txnId': txnId,
      });
    }
  }

  @override
  onPaymentFailure(dynamic response) {
    if (_isProcessingCallback) {
      debugPrint("⚠️ Already processing callback, ignoring duplicate");
      return;
    }
    
    _isProcessingCallback = true;
    
    debugPrint("❌ Payment Failed: $response");
    
    String errorMessage = "Payment Failed";
    String? errorCode;
    
    if (response is Map) {
      errorCode = response['errorCode']?.toString() ?? 
                  response['error_code']?.toString();
      final errorMsg = response['errorMsg']?.toString() ?? 
                      response['error_message']?.toString() ?? 
                      response['error']?.toString() ?? 
                      response['result']?.toString();
      
      if (errorMsg != null && errorMsg.isNotEmpty) {
        errorMessage = "Payment Failed: $errorMsg";
      }
      
      debugPrint("Error Code: $errorCode");
      debugPrint("Error Message: $errorMsg");
    }
    
    _showSnack(errorMessage);
    
    if (mounted) {
      Navigator.of(context).pop({
        'status': 'failure',
        'response': response,
        'errorCode': errorCode,
      });
    }
  }

  @override
  onPaymentCancel(Map? response) {
    if (_isProcessingCallback) {
      debugPrint("⚠️ Already processing callback, ignoring duplicate");
      return;
    }
    
    _isProcessingCallback = true;
    
    debugPrint("⚠️ Payment Cancelled: $response");
    
    _showSnack("Payment Cancelled");
    
    if (mounted) {
      Navigator.of(context).pop({
        'status': 'cancelled',
        'response': response,
      });
    }
  }

  @override
  onError(Map? response) {
    if (_isProcessingCallback) {
      debugPrint("⚠️ Already processing callback, ignoring duplicate");
      return;
    }
    
    _isProcessingCallback = true;
    
    debugPrint("❌ PayU Error: $response");
    
    String errorMessage = "Something went wrong";
    String? errorCode;
    
    if (response != null) {
      errorCode = response['errorCode']?.toString();
      final error = response['errorMsg']?.toString() ?? 
                   response['error']?.toString() ?? 
                   response['error_message']?.toString();
      
      if (error != null && error.isNotEmpty) {
        errorMessage = "Error: $error";
      }
      
      // Check for WebView crash
      if (error?.toLowerCase().contains('renderer') == true || 
          error?.toLowerCase().contains('crash') == true) {
        errorMessage = "Payment window crashed. Please try again.";
      }
      
      // Specific handling for hash generation error
      if (errorCode == '100' || errorMessage.contains('generate Hash')) {
        errorMessage = "Payment initialization failed. Please try again.";
      }
    }
    
    _showSnack(errorMessage);
    
    if (mounted) {
      Navigator.of(context).pop({
        'status': 'error',
        'response': response,
        'errorCode': errorCode,
      });
    }
  }

  void _startPayment() {
    if (_isPaymentStarted) {
      debugPrint("⚠️ Payment already started, ignoring duplicate call");
      return;
    }

    try {
      _isPaymentStarted = true;
      final payUData = widget.createOrderDataModel!.data!.payUData!;
      final hashes = widget.createOrderDataModel!.data!.hashes;

      debugPrint("💳 Starting payment:");
      debugPrint("Key: ${payUData.key}");
      debugPrint("Amount: ${payUData.amount}");
      debugPrint("TxnId: ${payUData.txnid}");
      debugPrint("Email: ${payUData.email}");
      debugPrint("Phone: ${payUData.phone}");

      final String txnId = payUData.txnid!;

      final Map<String, dynamic> payUPaymentParams = {
        PayUPaymentParamKey.key: payUData.key!,
        PayUPaymentParamKey.amount: payUData.amount!,
        PayUPaymentParamKey.productInfo: payUData.productinfo!,
        PayUPaymentParamKey.firstName: payUData.firstname!,
        PayUPaymentParamKey.email: payUData.email!,
        PayUPaymentParamKey.phone: payUData.phone!,
        PayUPaymentParamKey.ios_surl: payUData.surl!,
        PayUPaymentParamKey.ios_furl: payUData.furl!,
        PayUPaymentParamKey.android_surl: payUData.surl!,
        PayUPaymentParamKey.android_furl: payUData.furl!,
        PayUPaymentParamKey.environment: "1", // 1 = Test, 0 = Production
        PayUPaymentParamKey.transactionId: txnId,
        PayUPaymentParamKey.userCredential: "${payUData.key}:${payUData.email}",
      };

      // Add static hashes if available
      if (hashes != null) {
        final additionalParams = <String, String>{};
        
        if (hashes.paymentRelatedDetailsForMobileSdk != null && 
            hashes.paymentRelatedDetailsForMobileSdk!.isNotEmpty) {
          additionalParams["payment_related_details_for_mobile_sdk"] = 
              hashes.paymentRelatedDetailsForMobileSdk!;
        }
        
        if (hashes.vasForMobileSdk != null && hashes.vasForMobileSdk!.isNotEmpty) {
          additionalParams["vas_for_mobile_sdk"] = hashes.vasForMobileSdk!;
        }
        
        if (hashes.payment != null && hashes.payment!.isNotEmpty) {
          additionalParams["payment"] = hashes.payment!;
        }
        
        if (additionalParams.isNotEmpty) {
          payUPaymentParams[PayUPaymentParamKey.additionalParam] = additionalParams;
          debugPrint("✅ Static hashes added: ${additionalParams.keys.join(', ')}");
        }
      }

      final Map<String, dynamic> payUCheckoutProConfig = {
        PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
        PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
        PayUCheckoutProConfigKeys.merchantName: "Hopzy",
        PayUCheckoutProConfigKeys.waitingTime: 45000, // Increased to 45 seconds
        PayUCheckoutProConfigKeys.autoSelectOtp: false, // Disabled to reduce load
        PayUCheckoutProConfigKeys.merchantResponseTimeout: 45000, // Added
      };

      debugPrint("🚀 Opening PayU checkout...");
      _checkoutPro.openCheckoutScreen(
        payUPaymentParams: payUPaymentParams,
        payUCheckoutProConfig: payUCheckoutProConfig,
      );
    } catch (e, st) {
      debugPrint("❌ Error starting payment: $e");
      debugPrint("Stack: $st");
      _showSnack("Failed to start payment");
      
      if (mounted) {
        Navigator.of(context).pop({
          'status': 'error',
          'error': e.toString(),
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 20),
              Text(
                'Please wait...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Initializing secure payment gateway',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hashCache.clear();
    super.dispose();
  }
}