/*
 * MIT License
 *
 * Copyright (c) 2021 avinash-gotluru
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/*
 * MIT License
 *
 * Copyright (c) 2021 avinash-gotluru
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import 'dart:async';

import 'package:flutter/services.dart';

///[CcAvenue] create the MethodChannel[cc_avenue] at Initial

class CcAvenue {
  static const MethodChannel _channel = const MethodChannel('cc_avenue');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
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
    String? transUrl,
    String? rsaKeyUrl,
    String? accessCode,
    String? merchantId,
    String? orderId,
    String? currencyType,
    String? amount,
    String? cancelUrl,
    String? redirectUrl,
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
