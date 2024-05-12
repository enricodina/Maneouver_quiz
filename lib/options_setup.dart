import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
//import 'dart:convert';
import 'dart:math'; // Import Random for random selection

class OptionsSetupPage extends StatefulWidget {
  const OptionsSetupPage({super.key});

  @override
  _OptionsSetupPageState createState() => _OptionsSetupPageState();
}

class _OptionsSetupPageState extends State<OptionsSetupPage> {
  String? selectedEvent;
  String? selectedSituation;
  List<String> events = [];
  List<String> situations = [];
  String? selectedEventName; // To store the selected event name for display
  int columnIndex = 0; // Current column index for the selected event
  late String tsvString; // TSV string variable
  List<bool> _isSelected = [true, false]; // Initial selection for PF/PM

  @override
  void initState() {
    super.initState();
    loadEvents();
    loadSituations();
  }

  Future<void> loadEvents() async {
    tsvString = await rootBundle.loadString('assets/maneouvre_data.tsv');
    List<List<String>> parsedTsv =
        tsvString.split('\n').map((line) => line.split('\t')).toList();
    setState(() {
      events = parsedTsv
          .map((row) => row[0])
          .toList(); // Assuming the event names are in the first column
      selectedEvent = events.isNotEmpty
          ? events[0]
          : null; // Select the first event by default
    });
  }

  Future<void> loadSituations() async {
    String situationString =
        await rootBundle.loadString('assets/situation.tsv');
    List<List<String>> parsedSituation =
        situationString.split('\n').map((line) => line.split('\t')).toList();
    setState(() {
      situations = parsedSituation
          .map((row) => row[0])
          .toList(); // Assuming the situations are in the second column
      selectedSituation = situations.isNotEmpty
          ? situations[0]
          : null; // Select the first situation by default
    });
  }

  // Function to select a random event from the list
  String selectRandomEvent() {
    Random random = Random();
    return events[random.nextInt(events.length)];
  }

  // Function to handle "Next" button pressed
  void onNextPressed() {
    setState(() {
      if (selectedEvent != null) {
        List<List<String>> parsedTsv =
            tsvString.split('\n').map((line) => line.split('\t')).toList();
        if (columnIndex <
            parsedTsv[events.indexOf(selectedEvent!)].length - 1) {
          // Increment the column index to display the content of the next column
          columnIndex++;
        } else {
          // Reset the column index if there is no more content in the row
          columnIndex = 0;
        }
      }
    });
  }

  // Method to determine text color based on content
  Color _getTextColor(String content) {
    if (content.contains('@')) {
      return Colors.red;
    } else if (content.contains('#')) {
      return Colors.green;
    } else if (content.contains('}')) {
      return Colors.blue;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options Setup'),
        actions: <Widget>[
          ToggleButtons(
            isSelected: _isSelected,
            onPressed: (int index) {
              setState(() {
                _isSelected =
                    _isSelected.map((isSelected) => !isSelected).toList();
              });
            },
            children: const <Widget>[
              Text('PF'),
              Text('PM'),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButton<String>(
              value: selectedSituation,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSituation = newValue;
                });
              },
              items: situations.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            DropdownButton<String>(
              value: selectedEvent,
              onChanged: (String? newValue) {
                setState(() {
                  selectedEvent = newValue;
                  // Reset selected event name and column index
                  selectedEventName = null;
                  columnIndex = 0;
                });
              },
              items: events.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (selectedEvent == 'Random') {
                    selectedEventName = selectRandomEvent();
                  } else {
                    selectedEventName = selectedEvent;
                  }
                });
              },
              child: const Text('Start'),
            ),
            const SizedBox(height: 20.0),
            if (selectedEventName !=
                null) // Display selected event name only if it's not null
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${_isSelected[0] ? 'PF' : 'PM'}     ',
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    '$selectedSituation,',
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    '   ${tsvString.split('\n')[events.indexOf(selectedEvent!)].split('\t')[0]}',
                  ),
                ],
              ),
            const SizedBox(height: 20.0),
            if (selectedEvent !=
                null) // Display column content only if an event is selected
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  // Text aligned to the left if content contains '@'
                  if (tsvString
                      .split('\n')[events.indexOf(selectedEvent!)]
                      .split('\t')[columnIndex]
                      .contains('@'))
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${tsvString.split('\n')[events.indexOf(selectedEvent!)].split('\t')[columnIndex]}',
                          style: TextStyle(
                            color: _getTextColor(tsvString
                                .split('\n')[events.indexOf(selectedEvent!)]
                                .split('\t')[columnIndex]),
                          ),
                        ),
                      ),
                    ),

                  // Text aligned to the right if content contains '#'
                  if (tsvString
                      .split('\n')[events.indexOf(selectedEvent!)]
                      .split('\t')[columnIndex]
                      .contains('#'))
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${tsvString.split('\n')[events.indexOf(selectedEvent!)].split('\t')[columnIndex]}',
                          style: TextStyle(
                            color: _getTextColor(tsvString
                                .split('\n')[events.indexOf(selectedEvent!)]
                                .split('\t')[columnIndex]),
                          ),
                        ),
                      ),
                    ),

                  // Centered text for all other cases
                  if (!tsvString
                          .split('\n')[events.indexOf(selectedEvent!)]
                          .split('\t')[columnIndex]
                          .contains('@') &&
                      !tsvString
                          .split('\n')[events.indexOf(selectedEvent!)]
                          .split('\t')[columnIndex]
                          .contains('#'))
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${tsvString.split('\n')[events.indexOf(selectedEvent!)].split('\t')[columnIndex]}',
                          style: TextStyle(
                            color: _getTextColor(tsvString
                                .split('\n')[events.indexOf(selectedEvent!)]
                                .split('\t')[columnIndex]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onNextPressed,
        child: const Icon(Icons.arrow_forward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
