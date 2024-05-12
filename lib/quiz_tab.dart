import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class QuizTab extends StatefulWidget {
  final String selectedPhase;
  final String selectedEvent;
  final bool isPF;
  final int selectedEventIndex;

  const QuizTab({
    Key? key,
    required this.selectedPhase,
    required this.selectedEvent,
    required this.isPF,
    required this.selectedEventIndex,
  }) : super(key: key);

  @override
  _QuizTabState createState() => _QuizTabState();
}

class _QuizTabState extends State<QuizTab> {
  double columnWidth = 0.0;
  int currentIndex = 0;
  List<int> numbers = [];
  List<String> tsvData = [];

  @override
  void initState() {
    super.initState();
    loadTSVData();
  }

  Future<void> loadTSVData() async {
    String tsvString = await rootBundle.loadString('assets/maneouvre_data.tsv');
    List<List<String>> parsedTsv =
        tsvString.split('\n').map((line) => line.split('\t')).toList();
    setState(() {
      tsvData = parsedTsv
          .elementAt(widget.selectedEventIndex)
          .map((data) => data.trim())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    columnWidth = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Return'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.selectedPhase}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '   ${widget.selectedEvent}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '   ${widget.isPF ? 'PF' : 'PM'}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Table(
                      defaultColumnWidth: FlexColumnWidth(1.0),
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.lightBlue),
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    '${widget.selectedPhase}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    '${widget.selectedEventIndex}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    '${widget.isPF ? 'PF' : 'PM'}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration:
                              BoxDecoration(color: Colors.grey.shade200),
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'L',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'C',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'R',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Add numbers to the table

                        for (int i = 0; i < numbers.length; i++)
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: tsvData[i].contains('@')
                                        ? Text(
                                            tsvData[i]
                                                .replaceAll('@', '')
                                                .replaceAll('"', ''),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: tsvData[i].contains('"')
                                                  ? Colors.green
                                                  : Colors.black,
                                            ),
                                          )
                                        : SizedBox(),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: !tsvData[i].contains('@') &&
                                            !tsvData[i].contains('#')
                                        ? Text(
                                            tsvData[i],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          )
                                        : SizedBox(),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: tsvData[i].contains('#')
                                        ? Text(
                                            tsvData[i]
                                                .replaceAll('#', '')
                                                .replaceAll('"', ''),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: tsvData[i].contains('"')
                                                  ? Colors.blue
                                                  : Colors.black,
                                            ),
                                          )
                                        : SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                if (numbers.length < tsvData.length) {
                  setState(() {
                    numbers.add(numbers.length + 1);
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(numbers.length < tsvData.length ? 'Next' : 'End'),
            ),
          ),
        ],
      ),
    );
  }
}


/*
children: [

      TableCell(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: tsvData[i].contains('@')
                ? Text(
                    tsvData[i].replaceAll('@', ''),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tsvData[i].contains('"')
                          ? Colors.green
                          : Colors.black,
                    ),
                  )
                : SizedBox(),
          ),
        ),
      ),

      TableCell(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: tsvData[i].contains('#')
                ? Text(
                    tsvData[i].replaceAll('#', ''),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tsvData[i].contains('"')
                          ? Colors.blue
                          : Colors.black,
                    ),
                  )
                : SizedBox(),
          ),
        ),
      ),

      TableCell(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: !tsvData[i].contains('@') &&
                    !tsvData[i].contains('#')
                ? Text(
                    tsvData[i].replaceAll('"', ''),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tsvData[i].contains('"')
                          ? Colors.black
                          : null,
                    ),
                  )
                : SizedBox(),
          ),
        ),
      ),

      TableCell(
        child: SizedBox(), // Empty cell for center column
      ),

      TableCell(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: tsvData[i].contains('"')
                ? Text(
                    tsvData[i],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tsvData[i].contains('#')
                          ? Colors.blue
                          : Colors.green,
                    ),
                  )
                : SizedBox(),
          ),
        ),
      ),
    ],
    */