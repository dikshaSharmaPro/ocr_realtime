import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';

class NewDoc extends StatefulWidget {
  final List<OcrText> words;

  const NewDoc({Key? key, required this.words}) : super(key: key);

  @override
  _NewDocState createState() => _NewDocState();
}

class _NewDocState extends State<NewDoc> {
  List<String> _csvData = [];
  List<String> finalWordss = [];
  List<String> _matches = [];
  List<String> newAbc = [];

  @override
  void initState() {
    super.initState();
    loadCsv();
    _convertWords();
  }

  void _convertWords() {
    // Convert widget.words to a list of strings
    finalWordss = widget.words.map((ocrText) => ocrText.value).toList();

    // Split each element in finalWordss into individual words
    // and flatten the resulting lists into a single list
    newAbc =
        finalWordss.expand((element) => element.split(RegExp(r'\s+'))).toList();

    // Convert newAbc to lowercase to ensure case-insensitive matching
    newAbc = newAbc.map((word) => word.toLowerCase()).toList();
  }

  Future<void> loadCsv() async {
    try {
      // Load the CSV file
      final data = await rootBundle.loadString('assets/products.csv');

      // Split the CSV data into lines
      List<String> lines = data.split('\n');

      // Remove any trailing empty lines
      lines.removeWhere((line) => line.trim().isEmpty);

      // Strip quotes from each line
      List<String> strippedLines = lines.map((line) {
        return line.replaceAll('"', '');
      }).toList();

      // Update the state with the stripped lines
      setState(() {
        _csvData = strippedLines;
      });

      // Check for matches
      findMatches();
    } catch (e) {
      print('Error loading or parsing CSV: $e');
    }
  }

  void findMatches() {
    List<String> matches = [];

    // Convert _csvData to lowercase
    List<String> lowerCaseCsvData =
        _csvData.map((line) => line.toLowerCase()).toList();

    for (var word in newAbc) {
      if (lowerCaseCsvData.contains(word)) {
        matches.add(word);
      }
    }

    setState(() {
      _matches = matches;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log(_csvData[22]);

          for (var word in newAbc) {
            debugPrint(word);
            debugPrint("---");
          }
        },
      ),
      appBar: AppBar(
        title: Text('CSV Matcher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CSV Data:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _csvData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_csvData[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Search List:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: newAbc.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(newAbc[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Matches Found from the CSV file and scanned text:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _matches.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _matches[index],
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
