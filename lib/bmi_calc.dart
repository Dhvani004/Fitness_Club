import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget{
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator>{
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  double? _bmi;
  String _result = '';

  void calculateBMI(){
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    if(height != null && weight !=null && height>0){
      final heightInMeters = height/100;
      final bmi= weight/ (heightInMeters*heightInMeters);

      String category;
      if (bmi< 18.5){
        category = 'Underweight';
      } else if (bmi<25){
        category = 'Normal weight';
      }else if (bmi<30){
        category = 'Overweight';
      }else{
        category = 'Obese';
      }

      setState(() {
        _bmi = bmi;
        _result = category;
      });
    }else{
      setState(() {
        _bmi = null;
        _result = 'Please enter valid height and weight!';
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:const Text("BMI Calculator"),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        decoration: const BoxDecoration(
color: const Color(0xFFFFF8DC),
        ),
        padding: const EdgeInsets.all(24),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your height (cm) and weight(kg): ',
              style: TextStyle(fontSize: 18,color: Colors.black, fontWeight: FontWeight.bold),
              textAlign:TextAlign.center,
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Height in cm',
                filled: true,
                fillColor:Colors.white,
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight in kg',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: calculateBMI, child: const Text('Calculate BMI'),
            style:ElevatedButton.styleFrom(
              backgroundColor:Colors.yellow,
              foregroundColor: Colors.black,
            ),),
            const SizedBox(height: 30,),
            if(_bmi != null)
              Column(
                children: [
                  Text(
                    'Your BMI: ${_bmi!.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize:22, color:Colors.black),
                  ),
                  Text(
                    'Category: $_result',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              )
            else
              Text(
                _result,
                style:const TextStyle(fontSize:18, color: Colors.yellow),
              ),
          ],
        )
      ),
    );
  }
}