import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_club_app/widgets/progress_charts.dart';

class WorkoutTrackerPage extends StatefulWidget{
  const WorkoutTrackerPage({super.key});

  @override
  State<WorkoutTrackerPage> createState()=>_WorkoutTrackerPageState();
}

class _WorkoutTrackerPageState extends State<WorkoutTrackerPage>{
  final List<String> workoutTypes = ['Cardio', 'Yoga', 'Abs', 'Strength'];
  String selectedType='Cardio';
  final TextEditingController workoutNameController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final GlobalKey<ProgressChartsState> _chartsKey=GlobalKey<ProgressChartsState>();

  bool isSaving = false;

  Future<void> refreshPage() async{
    _chartsKey.currentState?.fetchWorkoutData();
  }

  Future<void> saveWorkout() async{
    final user= FirebaseAuth.instance.currentUser;
    final name= workoutNameController.text.trim();
    final sets= setsController.text.trim();
    final reps= repsController.text.trim();

    if(name.isEmpty || sets.isEmpty || reps.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }
    setState(()=>isSaving=true);

    try{
      await FirebaseFirestore.instance.collection('workouts').add({
        'uid':user?.uid,
        'workoutType': selectedType,
        'workoutName': name,
        'sets':sets,
        'reps':reps,
        'timestamp':Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Workout saved")),);
      workoutNameController.clear();
      setsController.clear();
      repsController.clear();
      refreshPage();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save: $e")),);
    }finally{
      setState(()=>isSaving=false);
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Tracker"),
        backgroundColor: Colors.yellow,
      ),
      backgroundColor: const Color(0xFFFFF8DC),
      body:RefreshIndicator(onRefresh: refreshPage,child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),

      child:Column(
        children: [
          DropdownButtonFormField<String>(
            value:selectedType,
            decoration: const InputDecoration(
              labelText: 'Workout Type',
              border: OutlineInputBorder(),
            ),
            items:workoutTypes.map((type){
              return DropdownMenuItem(value:type, child:Text(type));
            }).toList(),
            onChanged: (val){
              if(val!=null) setState(()=>selectedType=val);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: workoutNameController,
            decoration: const InputDecoration(
              labelText: 'Workout Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16,),
          TextField(
            controller: setsController,
            decoration: const InputDecoration(
              labelText: 'Sets',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16,),
          TextField(
            controller: repsController,
            decoration: const InputDecoration(
              labelText: 'Reps',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isSaving ? null : saveWorkout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
            ),
            child: isSaving
                ? const CircularProgressIndicator()
                : const Text("Save Workout"),
          ),
          const SizedBox(height: 40),
        ProgressCharts(key: _chartsKey),
]
      )
      ))
    );
  }
}