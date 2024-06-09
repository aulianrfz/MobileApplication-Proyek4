import 'package:flutter/material.dart';
import 'mother.dart'; // Import MotherForm
import 'father.dart'; // Import FatherForm

class FormOrtu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mother');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                primary: Colors.blue,
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.pregnant_woman, // Ikoni sesuai dengan Mother
                    size: 30,
                  ),
                  Text(
                    'Mother',
                    style: TextStyle(fontSize: 20),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Icon(Icons.pregnant_woman),
                  ), // Untuk menyeimbangkan ikon di sisi kanan
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/father');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                primary: Colors.green,
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.face, // Ikoni sesuai dengan Father
                    size: 30,
                  ),
                  Text(
                    'Father',
                    style: TextStyle(fontSize: 20),
                  ),
                  Opacity(
                    opacity: 0.0,
                    child: Icon(Icons.face),
                  ), // Untuk menyeimbangkan ikon di sisi kanan
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FormOrtu(),
  ));
}
