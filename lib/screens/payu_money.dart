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
  final bool isTestMode;

  const PayUPaymentScreen({
    super.key,
    this.forPayment,
    this.createOrderDataModel,
    this.bpoint,
    this.selectedSeats,
    this.selectedPassenger,
    this.selectedBoardingPointDetails,
    this.selectedDroppingPointDetails,
    this.onPayuPaymentSuccess,
    this.isTestMode = false,
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
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    print("PayUData: ${widget.createOrderDataModel?.data?.payUData?.toJson()}");

    _checkoutPro = PayUCheckoutProFlutter(this);

    _timeoutTimer = Timer(const Duration(minutes: 5), () {
      if (mounted && !_isProcessingCallback) {
        debugPrint("⏱️ Payment timeout - closing screen");
        _handleTimeout();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted && _validatePaymentData()) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          _startPayment();
        }
      } else {
        _showSnack("Invalid payment data");
        Navigator.of(context).pop({'status': 'error', 'error': 'Invalid payment data'});
      }
    });
  }

  void _handleTimeout() {
    if (_isProcessingCallback) return;
    _isProcessingCallback = true;

    _showSnack("Payment session timed out");

    if (mounted) {
      Navigator.of(context).pop({
        'status': 'timeout',
        'error': 'Payment session exceeded maximum time',
      });
    }
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
      debugPrint("Hash String: ${hashString != null && hashString.length > 30 ? hashString.substring(0, 30) : hashString}...");
      debugPrint("Hash Type: $hashType");

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
          "payment_hash": hashes.payment ?? '', // ✅ Important alias
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

      debugPrint(
        "✅ Hash generated: ${generatedHash.length > 20 ? generatedHash.substring(0, 20) : generatedHash}...",
      );

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
  }) async
  {
    try {
      final requestBody = {
        'hashName': hashName,
        'hashString': hashString.trim(),
        if (hashType != null && hashType.isNotEmpty) 'hashType': hashType,
        if (postSalt != null && postSalt.isNotEmpty) 'postSalt': postSalt,
        'environment': widget.isTestMode ? 'test' : 'prod', // ✅ add this
      };

      final reqJson = jsonEncode(requestBody);
      debugPrint("🔐 Hash Request Body: ${reqJson.substring(0, reqJson.length > 100 ? 100 : reqJson.length)}...");


      final response = await http.post(
        Uri.parse('https://prodapi.hopzy.in/api/public/generate-hash'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 30));

      debugPrint("🔐 Hash Response Status: ${response.statusCode}");
      // debugPrint("🔐 Hash Response Body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}");
      final resBody = response.body;
      debugPrint("🔐 Hash Response Body: ${resBody.substring(0, resBody.length > 200 ? 200 : resBody.length)}");

      // Check if response is HTML (error page)
      if (response.body.trim().startsWith('<!DOCTYPE') ||
          response.body.trim().startsWith('<html')) {
        debugPrint("❌ Backend returned HTML instead of JSON");
        debugPrint("Response preview: ${response.body.substring(0, 200)}");
        return '';
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['hash'] != null) {
          final hash = data['hash'].toString();

          if (hash.isEmpty) {
            debugPrint("❌ Backend returned empty hash");
            return '';
          }

          return hash;
        } else {
          debugPrint("❌ Backend returned unsuccessful response: $data");
        }
      } else {
        debugPrint("❌ Backend error: ${response.statusCode} - ${response.body}");
      }

      return '';
    } catch (e) {
      debugPrint("❌ Hash generation error: $e");
      return '';
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;

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

  @override
  //old
  onPaymentSuccess(dynamic response) async {
    debugPrint("✅ onPaymentSuccess called");

    if (_isProcessingCallback) {
      debugPrint("⚠️ Already processing callback, ignoring duplicate");
      return;
    }

    _isProcessingCallback = true;
    _timeoutTimer?.cancel();

    debugPrint("✅ Payment Success Response: $response");

    String? paymentId;
    String? txnId;


// ✅ PayU Mobile returns String sometimes — convert to Map if needed
    dynamic data = response;

    try {
      if (response is String) {
        data = jsonDecode(response);
      }
    } catch (e) {
      debugPrint("⚠️ Response is not JSON, using raw value");
    }
    // ✅ Check if payuResponse is a String that needs decoding
    if (data is Map && data['payuResponse'] is String) {
      try {
        data['payuResponse'] = jsonDecode(data['payuResponse']);
      } catch (e) {
        debugPrint("⚠️ Could not decode payuResponse JSON: $e");
      }
    }

    // ✅ Now safely extract IDs
    if (data is Map) {
      final payuResp = data['payuResponse'];
      paymentId = payuResp?['id']?.toString() ??
          data['paymentId']?.toString() ??
          data['id']?.toString();

      txnId = payuResp?['txnid']?.toString() ??
          data['txnid']?.toString() ??
          data['transactionId']?.toString();
    }


    debugPrint("💳 Payment ID: $paymentId");
    debugPrint("🔖 Transaction ID: $txnId");

    _showSnack("Payment Successful!");

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;


    try
    {
      if (widget.onPayuPaymentSuccess != null) {
        debugPrint("🎉 Executing onPayuPaymentSuccess callback");
        widget.onPayuPaymentSuccess!();
      }
      debugPrint("Now in Payment success");

      await Future.delayed(const Duration(milliseconds: 200));

      if (!mounted) return;

      Navigator.of(context).pop({
        'status': 'success',
        'response': response,
        'paymentId': paymentId,
        'txnId': txnId,
        'bookingData': {
          'seats': widget.selectedSeats?.map((s) => s.toJson()).toList(),
          'passengers': widget.selectedPassenger?.map((p) => p.toJson()).toList(),
          'boardingPoint': widget.selectedBoardingPointDetails?.toJson(),
          'droppingPoint': widget.selectedDroppingPointDetails?.toJson(),
          'amount': widget.createOrderDataModel?.data?.payUData?.amount,
        },
      });
    } catch (e) {
      debugPrint("❌ Error in success callback: $e");
      if (mounted) {
        Navigator.of(context).pop({
          'status': 'success',
          'response': response,
          'paymentId': paymentId,
          'txnId': txnId,
          'error': 'Callback failed: $e',
        });
      }
    }
  }

  @override
  onPaymentFailure(dynamic response) {
    if (_isProcessingCallback) {
      debugPrint("⚠️ Already processing callback, ignoring duplicate");
      return;
    }

    _isProcessingCallback = true;
    _timeoutTimer?.cancel();

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
        'errorMessage': errorMessage,
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
    _timeoutTimer?.cancel();

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
    _timeoutTimer?.cancel();

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

      // Check for specific error codes
      if (errorCode == '5014') {
        errorMessage = "Payment gateway configuration error. Please contact support.";
        debugPrint("🔴 Error 5014: Backend returning HTML instead of JSON");
      } else if (error?.toLowerCase().contains('renderer') == true ||
          error?.toLowerCase().contains('crash') == true) {
        errorMessage = "Payment window crashed. Please try again.";
        debugPrint("🔴 WebView Renderer Crash Detected");
      } else if (errorCode == '100' || error?.contains('generate Hash') == true) {
        errorMessage = "Payment initialization failed. Please try again.";
      }
    }

    _showSnack(errorMessage);

    if (mounted) {
      Navigator.of(context).pop({
        'status': 'error',
        'response': response,
        'errorCode': errorCode,
        'errorMessage': errorMessage,
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
        PayUPaymentParamKey.environment: widget.isTestMode ? "1" : "0",
       // 1 = Test, 0 = Production
        PayUPaymentParamKey.transactionId: payUData.txnid!,
        PayUPaymentParamKey.userCredential: "${payUData.key}:${payUData.email}",

      };

      // Add static hashes if available
      if (hashes != null) {
        final additionalParams = <String, String>{};

        if (hashes.paymentRelatedDetailsForMobileSdk != null &&
            hashes.paymentRelatedDetailsForMobileSdk!.isNotEmpty) {
          additionalParams["payment_related_details_for_mobile_sdk"] =
              hashes.paymentRelatedDetailsForMobileSdk!;
          _hashCache["payment_related_details_for_mobile_sdk"] =
              hashes.paymentRelatedDetailsForMobileSdk!;
        }

        if (hashes.vasForMobileSdk != null && hashes.vasForMobileSdk!.isNotEmpty) {
          additionalParams["vas_for_mobile_sdk"] = hashes.vasForMobileSdk!;
          _hashCache["vas_for_mobile_sdk"] = hashes.vasForMobileSdk!;
        }

        if (hashes.payment != null && hashes.payment!.isNotEmpty) {
          additionalParams["payment"] = hashes.payment!;
          _hashCache["payment"] = hashes.payment!;
        }
        // ✅ Important: add merchant key to ensure native flow
        additionalParams["key"] = payUData.key!;

        if (additionalParams.isNotEmpty) {
          payUPaymentParams[PayUPaymentParamKey.additionalParam] = additionalParams;
          debugPrint("✅ Static hashes added: ${additionalParams.keys.join(', ')}");
        }
      }

      final Map<String, dynamic> payUCheckoutProConfig = {
        PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
        PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
        PayUCheckoutProConfigKeys.merchantName: "Hopzy",
        PayUCheckoutProConfigKeys.waitingTime: 15000,
        PayUCheckoutProConfigKeys.autoSelectOtp: false,
        PayUCheckoutProConfigKeys.merchantResponseTimeout: 15000,
        PayUCheckoutProConfigKeys.autoApprove: false,
        PayUCheckoutProConfigKeys.showCbToolbar:true,
      PayUCheckoutProConfigKeys.paymentModesOrder: [
      "UPI",
      "CARD",
      "WALLET",
      "NET_BANKING"
      ],

      };
      debugPrint("🔑 Final key: ${payUData.key}");
      debugPrint("🌍 Environment: ${widget.isTestMode ? 'TEST' : 'PROD'}");
      debugPrint("📦 Hashes sent: ${jsonEncode(hashes?.toJson())}");
      debugPrint("📦 Additional Params: ${jsonEncode(payUPaymentParams[PayUPaymentParamKey.additionalParam])}");

      debugPrint("🚀 Opening PayU checkout...");
      debugPrint("🔧 PayU Environment: ${widget.isTestMode ? 'TEST' : 'PRODUCTION'}");
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
        onWillPop: () async {
          if (!_isProcessingCallback) {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Cancel Payment?'),
                content: const Text('Are you sure you want to cancel this payment?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );

            if (shouldPop == true) {
              _isProcessingCallback = true;
              _timeoutTimer?.cancel();
              Navigator.of(context).pop({'status': 'cancelled', 'reason': 'user_cancelled'});
              return false;
            }
          }
          return false;
        },
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
    _timeoutTimer?.cancel();
    _hashCache.clear();
    super.dispose();
  }
}