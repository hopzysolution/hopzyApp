import 'package:flutter/material.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:ridebooking/bloc/booking_bloc/booking_bloc.dart';
import 'package:ridebooking/models/create_order_data_model.dart';

class PayUPaymentScreen extends StatefulWidget {
  final CreateOrderDataModel? createOrderDataModel;

  const PayUPaymentScreen({
    super.key,
    this.createOrderDataModel,
  });

  @override
  State<PayUPaymentScreen> createState() => _PayUPaymentScreenState();
}

class _PayUPaymentScreenState extends State<PayUPaymentScreen>
    implements PayUCheckoutProProtocol {
  late PayUCheckoutProFlutter _checkoutPro;
  bool _isPaymentStarted = false;

  @override
  void initState() {
    super.initState();
    _checkoutPro = PayUCheckoutProFlutter(this);

    // Validate data before starting payment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _validatePaymentData()) {
        _startPayment();
      } else {
        _showSnack("Invalid payment data");
        Navigator.of(context).pop();
      }
    });
  }

  /// Validate all required payment data
  bool _validatePaymentData() {
    final payUData = widget.createOrderDataModel?.data?.payUData;
    
    if (payUData == null) {
      debugPrint("❌ PayU data is null");
      return false;
    }

    // Check all required fields
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
        debugPrint("❌ Missing required field: $fieldName");
        return false;
      }
    }

    // Validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(payUData.email!)) {
      debugPrint("❌ Invalid email format: ${payUData.email}");
      return false;
    }

    // Validate phone format (basic check)
    if (payUData.phone!.length < 10) {
      debugPrint("❌ Invalid phone format: ${payUData.phone}");
      return false;
    }

    // Validate amount
    try {
      double amount = double.parse(payUData.amount!);
      if (amount <= 0) {
        debugPrint("❌ Invalid amount: ${payUData.amount}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Amount parsing error: ${payUData.amount}");
      return false;
    }

    debugPrint("✅ All payment data validated successfully");
    return true;
  }

@override
generateHash(Map response) async {
  try {
    // get the hash name (e.g. "payment_hash" or similar)
    final String hashName = response[PayUHashConstantsKeys.hashName]?.toString() ?? '';

    // your backend-generated hash stored in the model (if you already placed it there)
    final String? backendHash = widget.createOrderDataModel?.data?.payUData?.hash;

    print("Hash Name:--------- $hashName");
    print("Backend Hash:========= $backendHash");


    if (hashName.isEmpty || backendHash == null || backendHash.isEmpty) {
      debugPrint('generateHash: missing hashName or backend hash');
      _checkoutPro.hashGenerated(hash: {}); // fail-safe
      return;
    }

    // IMPORTANT: key must be the hashName string, value must be the hash string
    final Map<String, String> hashResponse = {
      hashName: backendHash,
    };

    debugPrint('generateHash -> returning: $hashResponse');
    _checkoutPro.hashGenerated(hash: hashResponse);
  } catch (e, st) {
    debugPrint('generateHash error: $e\n$st');
    _checkoutPro.hashGenerated(hash: {});
  }
}



  void _showSnack(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  @override
  onPaymentSuccess(dynamic response) {
    debugPrint("✅ Payment Success: $response");
    
    // Extract transaction details
    String? paymentId;
    String? txnId;
    
    if (response is Map) {
      paymentId = response['payuMoneyId']?.toString();
      txnId = response['txnid']?.toString();
      
      debugPrint("💰 Payment ID: $paymentId");
      debugPrint("📝 Transaction ID: $txnId");
    }
    
    _showSnack("Payment Successful! 🎉");
    
    // Navigate back with success result
    Navigator.of(context).pop({
      'status': 'success',
      'response': response,
      'paymentId': paymentId,
      'txnId': txnId,
    });
  }

  @override
  onPaymentFailure(dynamic response) {
    debugPrint("❌ Payment Failed: $response");
    
    String errorMessage = "Payment Failed";
    String? errorCode;
    
    if (response is Map) {
      errorCode = response['errorMsg']?.toString();
      final errorMsg = response['error_message']?.toString() ?? 
                      response['error']?.toString() ?? 
                      response['result']?.toString();
      
      if (errorMsg != null && errorMsg.isNotEmpty) {
        errorMessage = "Payment Failed: $errorMsg";
      }
      
      debugPrint("🚨 Error Code: $errorCode");
      debugPrint("🚨 Error Message: $errorMsg");
      debugPrint("🚨 Full Response: $response");
    }
    
    _showSnack(errorMessage);
    
    // Navigate back with failure result
    Navigator.of(context).pop({
      'status': 'failure',
      'response': response,
      'errorCode': errorCode,
    });
  }

  @override
  onPaymentCancel(Map? response) {
    debugPrint("⚠️ Payment Cancelled: $response");
    _showSnack("Payment Cancelled by User");
    
    Navigator.of(context).pop({
      'status': 'cancelled',
      'response': response,
    });
  }

  @override
  onError(Map? response) {
    debugPrint("⚠️ PayU Error: $response");
    
    String errorMessage = "Something went wrong";
    if (response != null) {
      final error = response['error']?.toString() ?? 
                   response['error_message']?.toString();
      if (error != null && error.isNotEmpty) {
        errorMessage = "Error: $error";
      }
    }
    
    _showSnack(errorMessage);
    
    Navigator.of(context).pop({
      'status': 'error',
      'response': response,
    });
  }

  void _startPayment() {
    if (_isPaymentStarted) return;
    
    try {
      _isPaymentStarted = true;
      final payUData = widget.createOrderDataModel!.data!.payUData!;
      
      // Log payment parameters for debugging
      debugPrint("🚀 Starting payment with parameters:");
      debugPrint("Key: ${payUData.key}");
      debugPrint("Amount: ${payUData.amount}");
      debugPrint("TxnId: ${payUData.txnid}");
      debugPrint("Email: ${payUData.email}");
      debugPrint("Phone: ${payUData.phone}");
      
      var payUPaymentParams = {
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
        PayUPaymentParamKey.environment: "1", // 0 => Production, 1 => Test
        PayUPaymentParamKey.transactionId: payUData.txnid!,
        // PayUPaymentParamKey.userCredential: widget.createOrderDataModel!.data!.userId?.toString() ?? "",
      };

      // Add optional parameters if available
      // if (payUData.udf1 != null) payUPaymentParams[PayUPaymentParamKey.udf1] = payUData.udf1!;
      // if (payUData.udf2 != null) payUPaymentParams[PayUPaymentParamKey.udf2] = payUData.udf2!;
      // if (payUData.udf3 != null) payUPaymentParams[PayUPaymentParamKey.udf3] = payUData.udf3!;
      // if (payUData.udf4 != null) payUPaymentParams[PayUPaymentParamKey.udf4] = payUData.udf4!;
      // if (payUData.udf5 != null) payUPaymentParams[PayUPaymentParamKey.udf5] = payUData.udf5!;

      _checkoutPro.openCheckoutScreen(
        payUPaymentParams: payUPaymentParams,
        payUCheckoutProConfig: {
          PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
          PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
        },
      );
      
    } catch (e) {
      debugPrint("❌ Error starting payment: $e");
      _showSnack("Failed to start payment: ${e.toString()}");
      Navigator.of(context).pop({
        'status': 'error',
        'error': e.toString(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text('Processing Payment'),
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      // ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Please wait...\nInitializing payment gateway',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}