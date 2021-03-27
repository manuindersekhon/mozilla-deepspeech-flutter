import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

typedef DSVersion = Pointer<Utf8> Function();
typedef DSNativeFreeStr = Void Function(Pointer<Utf8>);
typedef DSFreeStr = void Function(Pointer<Utf8>);

class DeepspeechFlutter {
  factory DeepspeechFlutter() => _instance;
  static final DeepspeechFlutter _instance = DeepspeechFlutter._internal();

  DeepspeechFlutter._internal() {
    _deepspeech = Platform.isAndroid
        ? DynamicLibrary.open("libdeepspeechlibc.so")
        : DynamicLibrary.process();

    _dsVersion =
        _deepspeech.lookupFunction<DSVersion, DSVersion>('deepspeech_verison');
    _dsFreeStr = _deepspeech
        .lookupFunction<DSNativeFreeStr, DSFreeStr>('deepspeech_free_str');
  }

  DynamicLibrary _deepspeech;

  // Reference to functions.
  DSVersion _dsVersion;
  DSFreeStr _dsFreeStr;

  String getVersion() {
    Pointer<Utf8> _version = _dsVersion();
    String value = Utf8.fromUtf8(_version);
    _dsFreeStr(_version);
    return value;
  }
}
