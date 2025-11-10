import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class SensorTestPage extends StatefulWidget {
  @override
  _SensorTestPageState createState() => _SensorTestPageState();
}

class _SensorTestPageState extends State<SensorTestPage> {
  String status = "Initializing...";
  int _steps = 0;

  @override
  void initState() {
    super.initState();
    Pedometer.stepCountStream.listen((event) {
      setState(() {
        _steps = event.steps;
        status = "Step updates working!";
      });
    }).onError((error) {
      setState(() {
        status = "Sensor not available or error: $error";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sensor Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Steps: $_steps", style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
