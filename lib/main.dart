import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:super_app/views/dev_home.dart';
import 'package:super_app/views/recipes_home.dart';
import 'package:super_app/views/plant_doctor_home.dart';
import 'package:super_app/views/bmi_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inter IIT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Super App'),
      routes: {
        '/recipes': (context) => RecipesHome(),
        '/doctor': (context) => PlantDoctorHome(),
        '/bmi': (context) => BMIPage(),
        '/dev': (context) => Developer(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomCard(
              title: 'Recipes',
              onTap: () {
                Navigator.of(context).pushNamed('/recipes');
              },
            ),
            CustomCard(
              title: 'Plant Doctor',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PlantDoctorLoadingScreen(),
                ));
              },
            ),
            CustomCard(
              title: 'BMI Calculator',
              onTap: () {
                Navigator.pushNamed(context, '/bmi');
              },
            ),
            CustomCard(
              title: 'Developer Info',
              onTap: () {
                Navigator.pushNamed(context, '/dev');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }
}

class PlantDoctorLoadingScreen extends StatefulWidget {
  @override
  _PlantDoctorLoadingScreenState createState() =>
      _PlantDoctorLoadingScreenState();
}

class _PlantDoctorLoadingScreenState extends State<PlantDoctorLoadingScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    preloadModel().then((isModelPreloaded) {
      setState(() {
        isLoading = false;
      });

      if (isModelPreloaded) {
        // Navigate to Plant Doctor screen
        Navigator.pushReplacementNamed(context, '/doctor');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to preload model.'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Doctor Loading'),
      ),
      body: Center(
        child: isLoading
            ? Center(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(70.0),
                child: Center(
                  child: Text(
                    "Please wait while we pre-load the Image Classification Model for you.",
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
            )
            : ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Back to Home'),
        ),
      ),
    );
  }
}

Future<bool> preloadModel() async {
  final apiUrl = 'https://apitest-6gkp.onrender.com/classify';
  bool isOk = false;
  try {
    final ByteData imageData =
    await rootBundle.load('assets/images/my_image.jpg');
    final buffer = imageData.buffer.asUint8List();

    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      buffer,
      filename: 'my_image.jpg',
    ));

    final client = http.Client();
    final response = await client.send(request);

    if (response.statusCode == 200) {
      isOk = true;
      print('Model preloaded successfully.');
    } else {
      print('Failed to preload model. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return isOk;
}
