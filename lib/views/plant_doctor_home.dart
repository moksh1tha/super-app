import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';

class PlantDoctorHome extends StatefulWidget {
  const PlantDoctorHome({Key? key}) : super(key: key);

  @override
  State<PlantDoctorHome> createState() => _PlantDoctorHomeState();
}

class _PlantDoctorHomeState extends State<PlantDoctorHome> {
  File? _image;
  String? _result;
  bool _isLoading = false;
  double? confidence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Doctor'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Feature Information Card
            Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'This feature employs a TensorFlow Lite classification model, trained on a diverse dataset of plant leaf images. This model helps to recognize and classify various plant diseases, providing users with disease class and a confidence score.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Uploaded Image',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      if (_image != null)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (_isLoading)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Classification Result Card
            Container(
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Classification Result',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      if (_result != null)
                        Text(
                          '$_result',
                          style: TextStyle(fontSize: 18),
                        ),
                      if (_result != null)
                        CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 13.0,
                        animation: true,
                        percent: confidence!/100,
                        center: new Text(
                          "${confidence!}%",
                          style:
                          new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        footer: new Text(
                          "Confidence Score",
                          style:
                          new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.purple,
                      ),
                      SizedBox(height:30),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            onPressed: _isLoading ? null : pickImage, // Disable button during loading
            label: const Text('Upload Image'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isLoading = true;
        print("Image uploaded: ${_image!.path}");
        _result = null;
      });

      classifyImage(_image!);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Image Selected'),
            content: Text('You didn\'t select an image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> classifyImage(File image) async {
    final apiUrl = 'https://apitest-6gkp.onrender.com/classify';

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      print(image.path);
      final client = http.Client();
      final response = await client.send(request);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(await response.stream.bytesToString());
        confidence = jsonResponse['confidence'];// Extract confidence value
        print(confidence);
        setState(() {
          _result = jsonResponse['class_name'];
          _isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
