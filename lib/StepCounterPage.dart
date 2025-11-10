import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCounterPage extends StatefulWidget {
  const StepCounterPage({Key? key}) : super(key: key);

  @override
  State<StepCounterPage> createState() => _StepCounterPageState();
}

class _StepCounterPageState extends State<StepCounterPage> {
  late Stream<StepCount> _stepCountStream;
  int _stepsToday = 0;
  int _startSteps = 0;
  int _goalSteps = 6000; // optional: you can make this user-configurable

  @override
  void initState() {
    super.initState();
    _initStepCounter();
  }

  Future<void> _initStepCounter() async {
    final prefs = await SharedPreferences.getInstance();
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Get the saved initial steps for today
    int savedStart = prefs.getInt('startSteps_$todayKey') ?? -1;

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(
          (StepCount event) async {
        if (savedStart == -1) {
          // First time today
          savedStart = event.steps;
          await prefs.setInt('startSteps_$todayKey', savedStart);
        }

        setState(() {
          _startSteps = savedStart;
          _stepsToday = event.steps - _startSteps;
        });
      },
      onError: (error) {
        print("Step Count Error: $error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_stepsToday / _goalSteps).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Step Counter"),
        backgroundColor: const Color(0xFFFFF8DC), // pastel yellow
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFFF8DC), // pastel yellow
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Steps Today",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(
                '$_stepsToday',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey.shade300,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 8),
              Text(
                "${((_stepsToday / _goalSteps) * 100).clamp(0, 100).toStringAsFixed(1)}% of $_goalSteps steps",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
