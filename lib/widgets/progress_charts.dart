import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressCharts extends StatefulWidget {
  const ProgressCharts({super.key});

  @override
  State<ProgressCharts> createState() => ProgressChartsState();
}

class ProgressChartsState extends State<ProgressCharts> {
  Map<String, int> workoutsPerDay = {};
  Map<String, int> typeCount = {};

  @override
  void initState() {
    super.initState();
    fetchWorkoutData();
  }

  Future<void> fetchWorkoutData() async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 6));
    final user = FirebaseAuth.instance.currentUser;
    print('Current user UID: ${user?.uid}');

    final snapshot = await FirebaseFirestore.instance
        .collection('workouts')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
        .where('uid', isEqualTo: user?.uid)
        .get();

    final Map<String, int> perDay = {};
    final Map<String, int> typeTotals = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final timestamp = (data['timestamp'] as Timestamp).toDate();
      final day = DateFormat('EEE').format(timestamp);
      final type = data['workoutType'] ?? 'Other';

      perDay[day] = (perDay[day] ?? 0) + 1;
      typeTotals[type] = (typeTotals[type] ?? 0) + 1;
    }

    setState(() {
      workoutsPerDay = perDay;
      typeCount = typeTotals;
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) =>
        DateFormat('EEE').format(DateTime.now().subtract(Duration(days: 6 - i))));
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          "📊 Workouts This Week",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.7,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 10,
              barGroups: days.asMap().entries.map((entry) {
                final index = entry.key;
                final label = entry.value;
                final count = workoutsPerDay[label] ?? 0;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: count.toDouble(),
                      color: Colors.yellow[800],
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      return Text(days[index % 7]);
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true,reservedSize: 28),
                ),
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "🥧 Workout Types",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: typeCount.entries.map((entry) {
                return PieChartSectionData(
                  title: entry.key,
                  value: entry.value.toDouble(),
                  radius: 50,
                  color: _getColor(entry.key),
                  titleStyle: const TextStyle(fontSize: 14),
                );
              }).toList(),
              centerSpaceRadius: 30,
              sectionsSpace: 2,
            ),
          ),
        )
      ],
    );
  }

  Color _getColor(String key) {
    switch (key.toLowerCase()) {
      case 'cardio':
        return Colors.redAccent;
      case 'yoga':
        return Colors.green;
      case 'abs':
        return Colors.blue;
      case 'strength':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }
}
