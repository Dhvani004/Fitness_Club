import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTestPage extends StatelessWidget {
  const FirestoreTestPage({super.key});

  Future<void> testFirestore(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection("test").add({
        'message': 'Hello Fire store',
        'timestamp': DateTime.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Fire store write successful")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Fire store write failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Fire store"),
        backgroundColor: Colors.yellow,
      ),
      backgroundColor: const Color(0xFFFFF8DC), // pastel yellow
      body: Center(
        child: ElevatedButton(
          onPressed: () => testFirestore(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.black,
          ),
          child: const Text("Run Fire store Test"),
        ),
      ),
    );
  }
}
