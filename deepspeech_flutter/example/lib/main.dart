import 'package:flutter/material.dart';
import 'package:deepspeech_flutter/deepspeech_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _deepspeech = DeepspeechFlutter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(_deepspeech.getVersion()),
        ),
      ),
    );
  }
}
