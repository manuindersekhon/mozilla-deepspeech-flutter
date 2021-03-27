#import "DeepspeechFlutterPlugin.h"
#if __has_include(<deepspeech_flutter/deepspeech_flutter-Swift.h>)
#import <deepspeech_flutter/deepspeech_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "deepspeech_flutter-Swift.h"
#endif

@implementation DeepspeechFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeepspeechFlutterPlugin registerWithRegistrar:registrar];
}
@end
