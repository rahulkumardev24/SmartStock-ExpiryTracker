import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartstock/utils/custom_text_style.dart';
import 'home_screen.dart'; // Replace with your actual home screen file

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Logo Scale Animation
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Navigate to HomeScreen after delay
    Timer(Duration(seconds: 3), () {
     /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // ✅ Fix: Navigate to HomeScreen
      );*/
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),

            // Animated Logo
            ScaleTransition(
              scale: _animation,
              child: Lottie.asset('assets/lottie/clock.json', height: 180),
            ),

            SizedBox(height: 20),

            // App Name with Fade-in Animation
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (context, double opacity, child) {
                return Opacity(opacity: opacity, child: child);
              },
              child: Text(
                "SmartStock",
                style: myTextStyle24(
                  fontWeight: FontWeight.bold,
                  fontFamily: "secondary"
                ),
              ),
            ),

            SizedBox(height: 10),

            // Tagline
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (context, double opacity, child) {
                return Opacity(opacity: opacity, child: child);
              },
              child: Text(
                "Track Your Grocery & Medicine Easily!",
                style: myTextStyle18(
                  fontWeight: FontWeight.bold,
                  fontColor: Colors.black54,
                ),
              ),
            ),

            Spacer(),

            // Bottom Tagline
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (context, double opacity, child) {
                return Opacity(opacity: opacity, child: child);
              },
              child: Text(
                "Stay Fresh, Stay Healthy!",
                style: myTextStyle18(
                  fontWeight: FontWeight.bold,
                  fontColor: Colors.black54,
                  fontFamily: "secondary"
                ),
              ),
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
