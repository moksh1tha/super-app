import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Developer extends StatefulWidget {
  const Developer({super.key});

  @override
  State<Developer> createState() => _DeveloperState();
}

class _DeveloperState extends State<Developer> {
  final String githubURL = 'https://github.com/ishashankmittal';
  final String linkedInURL = 'https://linkedin.com/in/shashankmittal27';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Developer Info'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/my_image.jpg'),
            SizedBox(height: 20),
            Text(
              'Shashank Mittal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Mechanical Engg. (22135114)',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                launch(githubURL);
              },
              child: Text(
                'GitHub: @ishashankmittal',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                launch(linkedInURL);
              },
              child: Text(
                'LinkedIn: linkedin.com/in/shashankmittal27/',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
