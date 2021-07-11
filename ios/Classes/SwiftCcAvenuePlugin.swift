import Flutter
import UIKit
import Foundation


public class SwiftCcAvenuePlugin: UIViewController, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cc_avenue", binaryMessenger: registrar.messenger())
    let instance = SwiftCcAvenuePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    // flutter cmds dispatched on iOS device :
        if call.method == "CC_Avenue" {
            let args = call.arguments as? Dictionary<String, Any>
            let transUrl = args?["transUrl"] as? String
            let rsaKeyUrl = args?["rsaKeyUrl"] as? String
            let accessCode = args?["accessCode"] as? String
            let merchantId = args?["merchantId"] as? String
            let orderId = args?["orderId"] as? String
            let currencyType = args?["currencyType"] as? String
            let amount = args?["amount"] as? String
            let cancelUrl = args?["cancelUrl"] as? String
            let redirectUrl = args?["redirectUrl"] as? String
            let controller:CCWebViewController = CCWebViewController()
            NSLog(transUrl ?? "")
            controller.transUrl = transUrl ?? ""
            controller.rsaKeyUrl = rsaKeyUrl ?? ""
            controller.accessCode = accessCode ?? ""
            controller.merchantId = merchantId ?? ""
            controller.orderId = orderId ?? ""
            controller.currency = currencyType ?? ""
            controller.amount = amount ?? ""
            controller.cancelUrl = cancelUrl ?? ""
            controller.redirectUrl = redirectUrl ?? ""
            //self.present(, animated: true, completion: nil)
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CCWebViewController") as! CCWebViewController
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                    if let detailVC = storyBoard.instantiateViewController(withIdentifier: "FlutterViewController") as? FlutterViewController {
//                        detailVC.bookRecord = record
//                        self.navigationController?.pushViewController(detailVC, animated: true)
//                    }
////            self.present(controller, animated: true)
//                // use number and times as required, for example....
            //self.navigationController?.pushViewController(controller, animated: true)
        } else if call.method == "getPlatformVersion" {
          result("Running on: iOS " + UIDevice.current.systemVersion)
        } else {
          result(FlutterMethodNotImplemented)
        }
  }
}
