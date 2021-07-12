#import "CcAvenueNewPlugin.h"
#if __has_include(<cc_avenue_new/cc_avenue_new-Swift.h>)
#import <cc_avenue_new/cc_avenue_new-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cc_avenue_new-Swift.h"
#endif

@implementation CcAvenueNewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCcAvenueNewPlugin registerWithRegistrar:registrar];
}
@end
