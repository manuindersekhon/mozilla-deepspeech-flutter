import Flutter
import UIKit

public class SwiftDeepspeechFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "deepspeech_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftDeepspeechFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "temp") {
      let res = deepspeech_verison()
    }
  }
}
