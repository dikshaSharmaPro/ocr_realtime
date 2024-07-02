import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:realtimecam/all_text.dart';
import 'package:realtimecam/newdoc.dart';

class OCRPage extends StatefulWidget {
  @override
  _OCRPageState createState() => _OCRPageState();
}

List<OcrText> words = [];

class _OCRPageState extends State<OCRPage> {
  int OCR_CAM = FlutterMobileVision.CAMERA_BACK;
  String word = "TEXT";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      //OcrTextList(words: words)
                      NewDoc(
                        words: words,
                      )),
            );
          },
        ),
        backgroundColor: Colors.white70,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Real time OCR'),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: _read,
                  child: const Text(
                    'Start Scanning',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Text(
                  " 'After scanning is done come back to this screen and press the circle button'")
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _read() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
          'After scanning is done go back and press the circle button'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'ACTION',
        onPressed: () {},
      ),
    ));
    try {
      words = await FlutterMobileVision.read(
        camera: OCR_CAM,
        waitTap: true,
      );

      setState(() {
        word = words[0].value;
        log(word);
      });
    } on Exception {
      words.add(OcrText('Unable to recognize the word'));
    }
  }
}
