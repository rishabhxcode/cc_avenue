import Flutter
import UIKit

public class SwiftCcAvenueNewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cc_avenue_new", binaryMessenger: registrar.messenger())
    let instance = SwiftCcAvenueNewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    let factory = CcAvenueViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "cc-avenue-view-type")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
