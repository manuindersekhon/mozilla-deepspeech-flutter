import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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
  String? _processedText;
  Uint8List? _wavFile;
  bool _wavFileLoaded = false;

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
              SizedBox(height: 40),
              Text('DeepSpeech Version: ${_deepspeech.getVersion()}',
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 40),
              Text('Model Sample Rate: $_sampleRate',
                  style: TextStyle(fontSize: 20)),
              SizedBox(height: 40),
              OutlinedButton(
                child: Text('Load WAV File'),
                onPressed: _loadWavFile,
              ),
              SizedBox(height: 40),
              if (_wavFileLoaded) ...[
                Text('Loaded: new-home-in-the-stars-16k.wav'),
                SizedBox(height: 10),
                OutlinedButton(
                  child: Text('Run Speech To Text'),
                  onPressed: _runSpeechToText,
                ),
              ],
              SizedBox(height: 40),
              if (_processedText != null) ...[
                Text(
                  'Converted Speech to Text:',
                  style: TextStyle(fontSize: 20),
                ),
                // SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(_processedText!,
                      style:
                          TextStyle(fontSize: 30, fontStyle: FontStyle.italic)),
                ),
              ],
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

  Future<void> _loadWavFile() async {
    final bytes = await rootBundle.load('assets/new-home-in-the-stars-16k.wav');
    _wavFile = bytes.buffer.asUint8List();

    setState(() {
      _wavFileLoaded = true;
    });
  }

  void _runSpeechToText() async {
    if (_wavFile != null) {
      final _result = _deepspeech.speechToText(_wavFile!);

      setState(() {
        _processedText = _result;
      });
    }
  }
}
