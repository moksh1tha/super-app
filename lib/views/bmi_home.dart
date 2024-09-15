import 'package:flutter/material.dart';

class BMIPage extends StatefulWidget {
  const BMIPage({Key? key}) : super(key: key);

  @override
  State<BMIPage> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  TextEditingController weightController = TextEditingController();
  TextEditingController feetController = TextEditingController();
  TextEditingController inchesController = TextEditingController();
  double bmi = 0.0;
  String bmiCategory = '';
  var bgColor=Colors.white;
  var cardBg;

  @override
  void dispose() {
    weightController.dispose();
    feetController.dispose();
    inchesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Container(
        color: bgColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: cardBg,
                  elevation: 4,
                  margin: EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Calculate your Body Mass Index (BMI) instantly by entering your weight (kg) and height (feet and inches). The background color indicates your health status.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (bmi > 0)
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: cardBg,
                    elevation: 4,
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Your BMI Result',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${bmi.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'You are $bmiCategory.',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Weight Input Card
              Card(
                color: cardBg,
                elevation: 4,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'Enter your Weight (kg)',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Weight (kg)',
                          errorText: _validateInput(weightController.text)
                              ? null
                              : 'Enter a valid weight',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Height Input Card
              Card(
                color: cardBg,
                elevation: 4,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'Enter your Height',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: feetController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Feet',
                                errorText: _validateInput(feetController.text)
                                    ? null
                                    : 'Enter a valid height',
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: inchesController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Inches',
                                errorText: _validateInput(inchesController.text)
                                    ? null
                                    : 'Enter a valid height',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    calculateBMI();
                  },
                  child: Text('Calculate BMI'),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateInput(String input) {
    return double.tryParse(input) != null;
  }

  void calculateBMI() {
    if (_validateInput(weightController.text) &&
        _validateInput(feetController.text) &&
        _validateInput(inchesController.text)) {
      double weight = double.parse(weightController.text);
      int feet = int.parse(feetController.text);
      int inches = int.parse(inchesController.text);

      double heightInMeters = (feet * 12 + inches) * 0.0254;

      double calculatedBMI = weight / (heightInMeters * heightInMeters);

      setState(() {
        bmi = calculatedBMI;
        bmiCategory = getBMICategory(calculatedBMI);
      });
    } else {
      setState(() {
        bmi = 0.0;
        bmiCategory = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter valid weight and height.'),
        ),
      );
    }
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      bgColor=Colors.blue.shade300;
      cardBg=Colors.blue.shade100;
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      bgColor=Colors.green.shade300;
      cardBg=Colors.green.shade100;
      return 'Healthy';
    } else if (bmi >= 25.0 && bmi <= 29.9) {
      bgColor=Colors.orange.shade300;
      cardBg=Colors.orange.shade100;
      return 'Overweight';
    } else {
      bgColor=Colors.red.shade300;
      cardBg=Colors.red.shade100;
      return 'Obese';
    }
  }
}
