#import "CcAvenuePlugin.h"
#if __has_include(<cc_avenue/cc_avenue-Swift.h>)
#import <cc_avenue/cc_avenue-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cc_avenue-Swift.h"
#endif

@implementation CcAvenuePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCcAvenuePlugin registerWithRegistrar:registrar];
}
@end
