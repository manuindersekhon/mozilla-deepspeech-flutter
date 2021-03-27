
import 'dart:async';

import 'package:flutter/services.dart';

class DeepspeechFlutter {
  static const MethodChannel _channel =
      const MethodChannel('deepspeech_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
