import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';
import '../utils/custom_text_style.dart';
import '../widgets/my_snack_message.dart';
import '../widgets/sliding_button.dart';
import 'dash_board_screen.dart';
import 'home_screen.dart'; // Replace with your actual home screen file

class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  TextEditingController _nameController = TextEditingController();

  /// save name
  Future<void> saveName() async {
    if (_nameController.text.isEmpty) {
      MySnackMessage(
        message: "Please enter your name",
        backgroundColor: Colors.red.shade400,
      ).show(context);
      return;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("name", _nameController.text.trim());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashBoardScreen(
          userName: _nameController.text.trim(),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final mqHeight = MediaQuery.of(context).size.height;
    final mqWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.main, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to SmartStock!",
                    style: myTextStyle24(
                      fontFamily: "secondary",
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: mqWidth * 0.7,
                    height: mqHeight * 0.4,
                    decoration: BoxDecoration(
                      color: Color(0xFF6DE6C1), // Card color
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 10,
                          offset: Offset(8, 8),
                        ),
                        BoxShadow(
                          color: Colors.white.withAlpha(100),
                          blurRadius: 10,
                          offset: Offset(-8, -8),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage("assets/icons/post.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Subtitle
                  Text(
                    "Your all-in-one solution for tracking groceries, medicines, and daily essentials effortlessly.",
                    style: myTextStyle18(),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 30),

                  // Username Input Field
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter your name",
                      hintStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Get Started Button
                  SlidingButton(
                      onComplete: () async {
                        await saveName();

                      },

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
