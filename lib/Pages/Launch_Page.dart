import 'package:flutter/material.dart';
import '../Models/ThemeAttribute.dart';
import '../Models/Utility.dart';
import 'HomePage.dart';

class LaunchPage extends StatefulWidget {
  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  // Variables
  final String _userEmail = "";
  final ThemeAttribute themeAttribute = ThemeAttribute();
  final Utility utility = Utility();

  @override
  void initState() {
    super.initState();

    // Navigate to HomePage after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 20.0),
                Text("Loading...", style: TextStyle(fontSize: 16)), // Placeholder
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Check login status (currently always navigates to '/home')
  void checkLoginStatus() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }
}