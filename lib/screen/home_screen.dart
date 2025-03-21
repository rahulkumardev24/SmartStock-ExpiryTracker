import 'package:flutter/material.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';

import 'grocery_screen.dart';
import 'medicine_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  /// Function to return the selected screen
  Widget _getSelectedScreen() {
    return _selectedIndex == 0 ? GroceryScreen() : MedicineScreen();
  }

  /// here we create function for greeting
  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 20) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getGreeting() , style: myTextStyle12(),),
          Text("Rahul kumar Sahu " , style: myTextStyle18(fontWeight: FontWeight.bold),),
        ],
      ) ,
        backgroundColor: Colors.white,
      ),
   backgroundColor: Colors.white,
      body: Column(
        children: [
          /// Custom Tab Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /// Grocery Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color:
                          _selectedIndex == 0
                              ? AppColors.main
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Grocery",
                      style: myTextStyle18(
                        fontWeight: FontWeight.bold,
                        fontColor:
                            _selectedIndex == 0 ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                ),

                /// Restaurant Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color:
                          _selectedIndex == 1
                              ? AppColors.main
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Medicine",
                      style: myTextStyle18(
                        fontWeight: FontWeight.bold,
                        fontColor:
                            _selectedIndex == 1 ? Colors.white : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Animated Screen Switching
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder:
                  (widget, animation) =>
                      FadeTransition(opacity: animation, child: widget),
              child: _getSelectedScreen(), // Display selected screen
            ),
          ),
        ],
      ),
    );
  }
}
