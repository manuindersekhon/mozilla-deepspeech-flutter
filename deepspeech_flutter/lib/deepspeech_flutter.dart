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
typedef NativeSpeechToText = Pointer<Utf8> Function(Pointer, Pointer<Uint8>, Uint64);
typedef SpeechToText = Pointer<Utf8> Function(Pointer, Pointer<Uint8>, int);
typedef NativeEnableScorer = Int32 Function(Pointer, Pointer<Utf8>);
typedef EnableScorer = int Function(Pointer, Pointer<Utf8>);
typedef NativeDisableScorer = Int32 Function(Pointer);
typedef DisableScorer = int Function(Pointer);
typedef NativeSetScorerAlphaBeta = Int32 Function(Pointer, Float, Float);
typedef SetScorerAlphaBeta = int Function(Pointer, double, double);

class DeepspeechFlutter {
  factory DeepspeechFlutter() => _instance;
  static final DeepspeechFlutter _instance = DeepspeechFlutter._internal();

  DeepspeechFlutter._internal() {
    _deepspeech = Platform.isAndroid ? DynamicLibrary.open("libdeepspeechlibc.so") : DynamicLibrary.process();

    _dsVersion = _deepspeech.lookupFunction<DSVersion, DSVersion>('deepspeech_verison');
    _dsFreeStr = _deepspeech.lookupFunction<DSNativeFreeStr, DSFreeStr>('deepspeech_free_str');
    _dsCreateModel = _deepspeech.lookupFunction<CreateModel, CreateModel>('create_model');
    _dsFreeModel = _deepspeech.lookupFunction<NativeFreeModel, FreeModel>('free_model');
    _dsModelSampleRate = _deepspeech.lookupFunction<NativeModelSampleRate, ModelSampleRate>('model_sample_rate');
    _dsSpeechToText = _deepspeech.lookupFunction<NativeSpeechToText, SpeechToText>('speech_to_text');
    _dsEnableScorer = _deepspeech.lookupFunction<NativeEnableScorer, EnableScorer>('enable_external_scorer');
    _dsDisableScorer = _deepspeech.lookupFunction<NativeDisableScorer, DisableScorer>('disable_external_scorer');
    _dsSetScorerAlphaBeta =
        _deepspeech.lookupFunction<NativeSetScorerAlphaBeta, SetScorerAlphaBeta>('set_scorer_alpha_beta');
  }

  late final DynamicLibrary _deepspeech;

  // Reference to functions.
  late final DSVersion _dsVersion;
  late final DSFreeStr _dsFreeStr;
  late final CreateModel _dsCreateModel;
  late final FreeModel _dsFreeModel;
  late final ModelSampleRate _dsModelSampleRate;
  late final SpeechToText _dsSpeechToText;
  late final EnableScorer _dsEnableScorer;
  late final DisableScorer _dsDisableScorer;
  late final SetScorerAlphaBeta _dsSetScorerAlphaBeta;

  // Pointer to loaded model state
  Pointer? _modelCtxPointer;

  String getVersion() {
    Pointer<Utf8> _version = _dsVersion();
    String value = _version.toDartString();
    _dsFreeStr(_version);
    return value;
  }

  void createModel(String modelPath) {
    Pointer<Utf8> _modelPath = modelPath.toNativeUtf8();
    _modelCtxPointer = _dsCreateModel(_modelPath);
    print('_modelCtxPointer: $_modelCtxPointer');
  }

  int getSampleRate() {
    if (_modelCtxPointer == null || _modelCtxPointer == nullptr) {
      return -1;
    }

    int _sampleRate = _dsModelSampleRate(_modelCtxPointer!);
    return _sampleRate;
  }

  String speechToText(Uint8List samples) {
    Pointer<Uint8> samplePointer = calloc.call<Uint8>(samples.length);
    for (int index = 0; index < samples.length; index++) {
      samplePointer.elementAt(index).value = samples[index];
    }

    Pointer<Utf8> _result = _dsSpeechToText(_modelCtxPointer!, samplePointer, samples.length);
    malloc.free(samplePointer);

    return _result.toDartString();
  }

  int enableExternalScorer(String scorerFilePath) {
    Pointer<Utf8> _path = scorerFilePath.toNativeUtf8();
    if (_modelCtxPointer == null || _modelCtxPointer == nullptr) {
      return -1;
    }

    int statusCode = _dsEnableScorer(_modelCtxPointer!, _path);
    return statusCode;
  }

  int disableExternalScorer() {
    if (_modelCtxPointer == null || _modelCtxPointer == nullptr) {
      return -1;
    }

    int statusCode = _dsDisableScorer(_modelCtxPointer!);
    return statusCode;
  }

  int setScorerAlphaBeta(double alpha, double beta) {
    if (_modelCtxPointer == null || _modelCtxPointer == nullptr) {
      return -1;
    }

    int statusCode = _dsSetScorerAlphaBeta(_modelCtxPointer!, alpha, beta);
    return statusCode;
  }
}
