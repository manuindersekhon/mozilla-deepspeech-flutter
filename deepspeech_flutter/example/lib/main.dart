import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:deepspeech_flutter/deepspeech_flutter.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _deepspeech = DeepspeechFlutter();
  int _sampleRate = 0;
  String _processedText;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mozilla DeepSpeech Example'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text('DeepSpeech Version: ${_deepspeech.getVersion()}'),
              SizedBox(height: 20),
              Text('Model Sample Rate: $_sampleRate'),
              SizedBox(height: 20),
              OutlineButton(
                child: Text('Load WAV File'),
                onPressed: _runSpeechToText,
              ),
              SizedBox(height: 20),
              if (_processedText != null) Text(_processedText),
            ],
          ),
        ),
      ),
    );
  }

  // Load deepspeech english pre-trained model.
  Future<void> _loadModel() async {
    final bytes =
        await rootBundle.load('assets/deepspeech-0.9.3-models.tflite');
    final directory = (await getApplicationDocumentsDirectory()).path;
    final buffer = bytes.buffer;
    final path = '$directory/deepspeech-0.9.3-models.tflite';
    await File(path).writeAsBytes(
        buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    _deepspeech.createModel(path);

    setState(() {
      _sampleRate = _deepspeech.getSampleRate();
    });
  }

  void _runSpeechToText() async {
    final bytes = await rootBundle.load('assets/new-home-in-the-stars-16k.wav');
    final _list = bytes.buffer.asUint8List();

    final _result = _deepspeech.speechToText(_list);

    setState(() {
      _processedText = _result;
    });
  }
}
