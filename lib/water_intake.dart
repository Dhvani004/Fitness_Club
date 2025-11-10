import 'package:flutter/material.dart';

class WaterIntakePage extends StatefulWidget {
  const WaterIntakePage({super.key});

  @override
  State<WaterIntakePage> createState() => _WaterIntakePageState();
}

class _WaterIntakePageState extends State<WaterIntakePage> {
  int waterGoal = 8;
  int currentIntake = 0;

  bool _hasShownAddMsg = false;
  bool _hasShownRemoveMsg = false;

  void _addGlass() {
    if (currentIntake < waterGoal) {
      setState(() {
        currentIntake++;
        _hasShownAddMsg = false;
      });
    } else if (!_hasShownAddMsg) {
      _hasShownAddMsg = true;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You've reached your goal!"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _removeGlass() {
    if (currentIntake > 0) {
      setState(() {
        currentIntake--;
        _hasShownRemoveMsg = false;
      });
    } else if (!_hasShownRemoveMsg) {
      _hasShownRemoveMsg = true;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No glass to remove!"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _editGoal() async {
    final controller = TextEditingController(text: waterGoal.toString());

    final newGoal = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Daily Water Goal"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Number of glasses"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final parsed = int.tryParse(controller.text);
              if (parsed != null && parsed > 0) {
                Navigator.of(context).pop(parsed);
              } else {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter a valid number")),
                );
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );

    if (newGoal != null) {
      setState(() {
        waterGoal = newGoal;
        currentIntake = 0;
        _hasShownAddMsg = false;
        _hasShownRemoveMsg = false;
      });
    }
  }

  @override
  void dispose() {
    ScaffoldMessenger.of(context).clearSnackBars();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fillLevel = currentIntake / waterGoal;
    fillLevel = fillLevel.clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Water Intake Tracker"),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            onPressed: _editGoal,
            icon: const Icon(Icons.edit),
            tooltip: "Edit Goal",
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFF8DC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Daily Goal: $waterGoal Glasses",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      border: Border.all(color: Colors.blue, width: 4),
                      color: Color(0xFFDADADA),
                    ),
                    child: ClipOval(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          FractionallySizedBox(
                            heightFactor: fillLevel,
                            child: Container(color: Colors.blue),
                          ),
                          Center(
                            child: Icon(
                              Icons.water_drop,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "$currentIntake / $waterGoal Glasses",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ElevatedButton.icon(
                //   onPressed: _addGlass,
                //   icon: const Icon(Icons.add),
                //   label: const Text("Add Glass"),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blue,
                //     foregroundColor: Colors.white,
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 20, vertical: 12),
                //   ),
                // ),
                // const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _removeGlass,
                  icon: const Icon(Icons.remove),
                  label: const Text("Remove Glass"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
          const SizedBox(width: 20),

        ElevatedButton.icon(
        onPressed: _addGlass,
        icon: const Icon(Icons.add),
        label: const Text("Add Glass"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 12),
        ),
      )],
            )
          ],
        ),
      ),
    );
  }
}
