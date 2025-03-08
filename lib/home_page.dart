import 'package:flutter/material.dart';
import 'package:my_stt/widget/lang_dropdown.dart';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool speechEnabled = false;
  String wordsSpoken = '';
  double confidenceLevel = 0;
  final Map<String, String> langMap = {
    "Uzbek": "uz_UZ",
    "Arabic": "ar_AR",
    "Russian": "ru_RU",
    "English": "en_EN"
  };


  String localeId = "ar_AR";

  @override
  void initState() {
    super.initState();

    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    setState(() {

    });
  }

  _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, localeId: localeId);
    confidenceLevel = 0;

    setState(() {
    });
  }

  _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult? result) {
    setState(() {
      wordsSpoken = "${result?.recognizedWords}";
      confidenceLevel = result?.confidence ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Speech Demo"
        ),
        actions: [
          LangDropdown(
            languages: langMap.keys.toList(),
            onTap: (String value) async {
              localeId = langMap[value]!;
              await _stopListening();
              _startListening();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(24),
              child: Text(
                _speechToText.isListening
                    ? "listening"
                    : speechEnabled
                      ? "Tap the microphone to start listening..."
                      : "Speech not available"
              ),
            ),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Text(
                  wordsSpoken,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w300
                  ),
                ),
              )
            ),

            if (_speechToText.isNotListening && confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 56),
                child: Text(
                  "Confidence: ${(confidenceLevel * 100).toStringAsFixed(1)}%",
                  style: TextStyle(fontSize: 30),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        backgroundColor: Colors.blueAccent,
        child: Icon(
          _speechToText.isListening ? Icons.stop : Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}
