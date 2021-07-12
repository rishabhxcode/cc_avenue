import 'dart:async';

import 'package:flutter/services.dart';

class CcAvenueNew {
  static const MethodChannel _channel = const MethodChannel('cc_avenue_new');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
