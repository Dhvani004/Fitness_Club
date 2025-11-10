import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_club_app/workout_tracker.dart';
import 'package:flutter/material.dart';
import 'package:fitness_club_app/bmi_calc.dart';
import 'login.dart';
import 'package:fitness_club_app/water_intake.dart';
import 'package:fitness_club_app/StepCounterPage.dart';
import 'package:fitness_club_app/sensor_test_page.dart';
import 'package:pedometer/pedometer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitness Club"),
        backgroundColor: Colors.greenAccent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          )
        ],
      ),
      backgroundColor:  Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Welcome, $displayName 👋',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),

            // ✅ BMI Button
            _buildButton(
              context,
              icon: Icons.monitor_weight,
              label: 'BMI Calculator',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BMICalculator()),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Workout Tracker Button
            _buildButton(
              context,
              icon: Icons.fitness_center,
              label: 'Workout Tracker',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WorkoutTrackerPage()),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Water Intake Tracker Button
            _buildButton(
              context,
              icon: Icons.water_drop,
              label: 'Water Intake Tracker',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WaterIntakePage()),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Step Counter Button
            _buildButton(
              context,
              icon: Icons.directions_walk,
              label: 'Step Counter',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StepCounterPage()),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => SensorTestPage()),
            //     );
            //   },
            //   child: Text("Test Step Sensor"),
            // ),


          ],
        ),
      ),
    );
  }

  // Reusable button builder method
  Widget _buildButton(BuildContext context,
      {required IconData icon,
        required String label,
        required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void checkSensor() async {
    try {
      Stream<StepCount> stepCountStream = Pedometer.stepCountStream;
      stepCountStream.listen(
            (event) {
          print("Steps detected: ${event.steps}");
        },
        onError: (error) {
          print("Error: $error");
        },
        cancelOnError: true,
      );
    } catch (e) {
      print("Exception: $e");
    }
  }

}
