#import "CcAvenuePlugin.h"
#import "CCWebViewController.h"

@implementation CcAvenuePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"cc_avenue"
            binaryMessenger:[registrar messenger]];
  CcAvenuePlugin* instance = [[CcAvenuePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if ([@"CC_Avenue" isEqualToString:call.method]) {
      NSLog(@"button clicked");
      
//      UIViewController *flutterViewController = [[FlutterViewController alloc] init];
//
//      UINavigationController *nav = [[UINavigationController alloc] init];
      
      CCWebViewController *controller = [[CCWebViewController alloc] init];

      UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    //  [navController pushViewController:web animated:NO];
     
//      CCWebViewController* controller = [self story initi:@"CCWebViewController"];
      
      
//      controller.accessCode = self.accessCode.text;
//      controller.merchantId = self.merchantId.text;
//      controller.amount = self.amount.text;
//      controller.currency = self.currency.text;
//      controller.orderId = self.orderId.text;
//      controller.redirectUrl = self.redirectUrl.text;
//      controller.cancelUrl = self.cancelUrl.text;
//      controller.rsaKeyUrl = self.rsaKeyUrl.text;
   
      controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//      [self presentViewController:controller animated:YES completion:nil];
      NSLog(@"button clicked End");
      
  } else {
    result(FlutterMethodNotImplemented);
  }
    

}
@end
