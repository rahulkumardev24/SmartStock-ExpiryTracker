import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/custom_text_style.dart';
import 'dash_board_screen.dart';
import 'get_start_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();

    /// Logo Scale Animation
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();

    /// Animate Lottie visibility after 500ms
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        isVisible = true;
      });
    });

    /// Navigate to HomeScreen after delay
    Timer(Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      checkName();
    });
  }

  Future<void> checkName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final getName = preferences.get("name");
    if (getName == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetStartedScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashBoardScreen(userName: getName.toString()),
        ),
      );
    }
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

            /// Animated Logo
            AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.0,
              duration: Duration(seconds: 1),
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
                "SmartExpiry Tracker",
                style: myTextStyle24(
                  fontWeight: FontWeight.bold,
                  fontFamily: "secondary",
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
                  fontFamily: "secondary",
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
