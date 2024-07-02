// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
// import 'package:realtimecam/ocrdetection.dart';

// class OcrTextList extends StatefulWidget {
//   final List<OcrText> words;

//   const OcrTextList({super.key, required this.words});

//   @override
//   State<OcrTextList> createState() => _OcrTextListState();
// }

// class _OcrTextListState extends State<OcrTextList> {
//   List<OcrText> matchedWords = [];
//   String fileContent = "";

//   @override
//   void initState() {
//     super.initState();
//     _loadTxtFile();
//   }

//   Future<void> _loadTxtFile() async {
//     final content = await rootBundle.loadString('assets/products.txt');
//     setState(() {
//       fileContent = content;
//       _findMatches();
//     });
//   }

//   void _findMatches() {
//     final fileWords = fileContent.split(RegExp(r'\s+')); // Split by whitespace
//     final matches = words.where((word) => fileWords.contains(word)).toList();
//     setState(() {
//       matchedWords = matches;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: words.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(words[index].value),
//                 );
//               },
//             ),
//             Text(
//               'Matched Words:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             if (matchedWords.isEmpty)
//               Text('No matches found.')
//             else
//               ...matchedWords.map((word) => Text(word.value)).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';

class OcrTextList extends StatefulWidget {
  final List<OcrText> words;

  const OcrTextList({Key? key, required this.words}) : super(key: key);

  @override
  State<OcrTextList> createState() => _OcrTextListState();
}

class _OcrTextListState extends State<OcrTextList> {
  List<String> finalWords = [];
  List<String> matchedWords = [];
  List<String> csvWords = [];
  bool showFullContent = false;

  @override
  void initState() {
    super.initState();
    _convertWords();
    _loadCsvFile();
  }

  void _convertWords() {
    finalWords = widget.words.map((ocrText) => ocrText.value).toList();
  }

  Future<void> _loadCsvFile() async {
    final content = await rootBundle.loadString('assets/products.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(content);

    List<String> csvWords = [];
    for (var row in csvTable) {
      if (row.isNotEmpty) {
        csvWords.add(row[0].toString()); // Assuming single column CSV
      }
    }

    setState(() {
      this.csvWords = csvWords;
      _findMatches();
    });

    // Debugging to verify CSV content
    print('CSV Table:');
    csvTable.forEach((row) {
      print(row);
    });
    print('CSV Words: $csvWords');
  }

  void _findMatches() {
    print('Final Words: $finalWords');
    print('CSV Words: $csvWords');

    final matches =
        finalWords.where((word) => csvWords.contains(word)).toList();

    print('Matched Words: $matches');

    setState(() {
      matchedWords = matches;
    });
  }

  void _toggleFullContent() {
    setState(() {
      showFullContent = !showFullContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR Text List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: finalWords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(finalWords[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Matched Words:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (matchedWords.isEmpty)
              Text('No matches found.')
            else
              ...matchedWords.map((word) => Text(word)).toList(),
            SizedBox(height: 20),
            if (showFullContent)
              Text(
                csvWords.join(', '),
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFullContent,
        child: Icon(Icons.visibility),
      ),
    );
  }
}
