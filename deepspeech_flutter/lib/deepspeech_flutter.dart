import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

typedef DSVersion = Pointer<Utf8> Function();
typedef DSNativeFreeStr = Void Function(Pointer<Utf8>);
typedef DSFreeStr = void Function(Pointer<Utf8>);
typedef CreateModel = Pointer Function(Pointer<Utf8>);
typedef NativeFreeModel = Void Function(Pointer);
typedef FreeModel = void Function(Pointer);
typedef NativeModelSampleRate = Uint64 Function(Pointer);
typedef ModelSampleRate = int Function(Pointer);
typedef NativeSpeechToText = Pointer<Utf8> Function(
    Pointer, Pointer<Uint8>, Uint64);
typedef SpeechToText = Pointer<Utf8> Function(Pointer, Pointer<Uint8>, int);

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
    _dsCreateModel =
        _deepspeech.lookupFunction<CreateModel, CreateModel>('create_model');
    _dsFreeModel =
        _deepspeech.lookupFunction<NativeFreeModel, FreeModel>('free_model');
    _dsModelSampleRate =
        _deepspeech.lookupFunction<NativeModelSampleRate, ModelSampleRate>(
            'model_sample_rate');
    _dsSpeechToText = _deepspeech
        .lookupFunction<NativeSpeechToText, SpeechToText>('speech_to_text');
  }

  DynamicLibrary _deepspeech;

  // Reference to functions.
  DSVersion _dsVersion;
  DSFreeStr _dsFreeStr;
  CreateModel _dsCreateModel;
  FreeModel _dsFreeModel;
  ModelSampleRate _dsModelSampleRate;
  SpeechToText _dsSpeechToText;

  // Pointer to loaded model state
  Pointer _modelCtxPointer;

  String getVersion() {
    Pointer<Utf8> _version = _dsVersion();
    String value = Utf8.fromUtf8(_version);
    _dsFreeStr(_version);
    return value;
  }

  void createModel(String modelPath) {
    Pointer<Utf8> _modelPath = Utf8.toUtf8(modelPath);
    _modelCtxPointer = _dsCreateModel(_modelPath);
    print('_modelCtxPointer: $_modelCtxPointer');
  }

  int getSampleRate() {
    if (_modelCtxPointer == null) {
      return -1;
    }

    int _sampleRate = _dsModelSampleRate(_modelCtxPointer);
    return _sampleRate;
  }

  String speechToText(Uint8List samples) {
    Pointer<Uint8> samplePointer = allocate<Uint8>(count: samples.length);
    for (int i = 0; i < samples.length; i++) {
      samplePointer.elementAt(i).value = samples[i];
    }
    Pointer<Utf8> _result =
        _dsSpeechToText(_modelCtxPointer, samplePointer, samples.length);
    free(samplePointer);

    return Utf8.fromUtf8(_result);
  }
}
