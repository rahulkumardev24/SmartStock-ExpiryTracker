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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            // Animated Logo
            ScaleTransition(
              scale: _animation,
              child: Lottie.asset('assets/lottie/clock.json'),
            ),

            SizedBox(height: 20),

            // Fade-in Text Animation
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (context, double opacity, child) {
                return Opacity(opacity: opacity, child: child);
              },
              child: Text(
                "SmartStock",
                style: myTextStyle24(fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            // Fade-in Text Animation
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(seconds: 2),
              builder: (context, double opacity, child) {
                return Opacity(opacity: opacity, child: child);
              },
              child: Text(
                " Manage and track home products",
                style: myTextStyle18(
                  fontWeight: FontWeight.bold,
                  fontColor: Colors.black54,
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
