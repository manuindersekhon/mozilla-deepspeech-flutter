# Mozilla DeepSpeech Flutter

This is an example repo for the article [Mozilla DeepSpeech Engine in Flutter Using Dart FFI](https://techblog.geekyants.com/mozilla-deepspeech-engine-in-flutter-using-dart-ffi)

- [libdeepspeech_0.9.3](./libdeepspeech_0.9.3) contains android arm64-v8a and armeabi-v7a shared libraries and iOS static framework for DeepSpeech 0.9.3.

- [libc_deepspeech](./libc_deepspeech) is the C library built for the flutter plugin.

- [deepspeech_flutter](,.deepspeech_flutter) is the flutter plugin that integrates the above C library.


**Note:** Please try the example app on *physical devices* only. Binaries for simulators are not present in example app.