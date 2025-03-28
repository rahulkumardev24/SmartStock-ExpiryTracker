import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartstock/screen/dash_board_screen.dart';
import 'package:smartstock/screen/get_start_screen.dart';
import 'package:smartstock/utils/custom_text_style.dart';


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

      checkName();

    });
  }

  Future<void> checkName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance() ;
    final getName = preferences.get("name") ;
    if(getName == null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> GetStartedScreen()));
    }else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DashBoardScreen(userName:getName.toString()))) ;
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
