import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:maneouver_quiz/quiz_tab.dart'; // Import the QuizTab

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String? selectedPhase;
  String? selectedEvent;
  bool isPF = true;
  late String tsvString;

  List<String> phases = [];
  List<String> events = [];

  @override
  void initState() {
    super.initState();
    loadPhases();
    loadEvents();
  }

  Future<void> loadPhases() async {
    String phaseString = await rootBundle.loadString('assets/situation.tsv');
    List<List<String>> parsedPhases =
        phaseString.split('\n').map((line) => line.split('\t')).toList();
    setState(() {
      phases = parsedPhases.map((row) => row[0]).toList();
      selectedPhase = phases.isNotEmpty ? phases[0] : null;
    });
  }

  Future<void> loadEvents() async {
    tsvString = await rootBundle
        .loadString('assets/maneouvre_data.tsv'); // Load TSV file
    List<List<String>> parsedEvents =
        tsvString.split('\n').map((line) => line.split('\t')).toList();
    setState(() {
      events = parsedEvents.map((row) => row[0]).toList();
      selectedEvent = events.isNotEmpty ? events[0] : null;
    });
  }

  String selectRandomEvent() {
    return events.skip(1).toList()[(events.skip(1).length *
            (DateTime.now().millisecondsSinceEpoch % 1000) /
            1000)
        .floor()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to Quiz App',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              DropdownButton<String>(
                value: selectedPhase,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPhase = newValue;
                  });
                },
                items: phases.map<DropdownMenuItem<String>>((String value) {
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
              ToggleButtons(
                isSelected: [isPF, !isPF],
                onPressed: (int index) {
                  setState(() {
                    isPF = index == 0;
                  });
                },
                children: const <Widget>[
                  Text('PF'),
                  Text('PM'),
                ],
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  int selectedEventIndex = events.indexOf(selectedEvent!);
                  if (selectedEvent! == events[0]) {
                    setState(() {
                      selectedEvent = selectRandomEvent();
                    });
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizTab(
                        selectedPhase: selectedPhase!,
                        selectedEvent: selectedEvent!,
                        isPF: isPF,
                        selectedEventIndex: selectedEventIndex,
                        //tsvString: tsvString, // Pass tsvString here
                      ),
                    ),
                  );
                },
                child: const Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
