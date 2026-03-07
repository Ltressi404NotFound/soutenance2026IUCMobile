import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => Navigator.pushReplacementNamed(context, '/intro'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0056b3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150, height: 150,
              decoration: BoxDecoration(color: Color(0xFF28a745), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 5)),
              child: Icon(Icons.add, size: 100, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              "FirstAid Loum", 
              style: TextStyle(
                color: Colors.white, 
                fontSize: 32, 
                fontWeight: FontWeight.w900, // Correction de .black
                fontStyle: FontStyle.italic, // Correction de italic: true
              )
            ),
          ],
        ),
      ),
    );
  }
}