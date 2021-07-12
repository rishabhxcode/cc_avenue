import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cc_avenue_new/cc_avenue_new.dart';

void main() {
  const MethodChannel channel = MethodChannel('cc_avenue_new');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await CcAvenueNew.platformVersion, '42');
  });
}
