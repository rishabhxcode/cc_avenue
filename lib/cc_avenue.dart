import 'dart:async';

import 'package:flutter/services.dart';

///[CcAvenue] create the MethodChannel[cc_avenue] at Initial

class CcAvenue {
  static const MethodChannel _channel = const MethodChannel('cc_avenue');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
///[cCAvenueInit] Initialized the field requried for Payment GateWay
/// [transUrl] Transaction Url
/// [rsakeyUrl] RSA Key Url merchant Server getRSA API
/// [accessCode] Access Code given by CCAvenue
/// [merchantId] merchantId Code given by CCAvenue
/// [orderId] orderId you generate it or get this from merchant
/// [currencyType] currencyType Specify the currency type Like "INR","EU"...etc Please follow the documentation by CCAvenue
/// [amount] Transaction Amount
/// [cancelUrl] when the user cancel the request
/// [redirectUrl] After the Transaction it will redirect and shows the status either Success or Failed
  static Future<void> cCAvenueInit({
    String transUrl,
    String rsaKeyUrl,
    String accessCode,
    String merchantId,
    String orderId,
    String currencyType,
    String amount,
    String cancelUrl,
    String redirectUrl,
  }) async {
    await _channel.invokeMethod('CC_Avenue', {
      'transUrl': transUrl ?? '',
      'rsaKeyUrl': rsaKeyUrl ?? '',
      'accessCode': accessCode ?? '',
      'merchantId': merchantId ?? '',
      'orderId': orderId ?? '',
      'currencyType': currencyType ?? '',
      'amount': amount ?? '',
      'cancelUrl': cancelUrl ?? '',
      'redirectUrl': redirectUrl ?? ''
    });
  }
}
