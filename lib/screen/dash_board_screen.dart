import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../utils/colors.dart';
import '../utils/custom_text_style.dart';
import 'add_item_screen.dart';
import 'category_screen.dart';
import 'home_screen.dart';

class DashBoardScreen extends StatefulWidget {
  final String userName;

  DashBoardScreen({super.key, required this.userName});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(userName: widget.userName),
      CategoryScreen(),
    ];
  }

  /// Function to change tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    final mqHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: _screens[_selectedIndex], // Display selected screen

      /// Floating Action Button (FAB)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
        },
        elevation: 0,
        backgroundColor: AppColors.main,
        shape: const CircleBorder(),
        child: const FaIcon(FontAwesomeIcons.plus, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// Custom Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        height: mqHeight * 0.09,
        shape: const CircularNotchedRectangle(),
        color: AppColors.light,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /// Home Tab
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home_filled,
                    color: _selectedIndex == 0 ? Colors.green : Colors.black54,
                  ),
                  Text(
                    "Home",
                    style: myTextStyle15(
                      fontColor: _selectedIndex == 0 ? Colors.green : Colors.black54,
                      fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            /// Add Item (Centered)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20), // Space to align with FAB
                Text(
                  "Add Item",
                  style: myTextStyle15(
                    fontWeight: FontWeight.bold,
                    fontColor: Colors.black54,
                  ),
                ),
              ],
            ),

            /// Category Tab
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.layerGroup,
                    color: _selectedIndex == 1 ? Colors.green : Colors.black54,
                  ),
                  Text(
                    "Category",
                    style: myTextStyle15(
                      fontColor: _selectedIndex == 1 ? Colors.green : Colors.black54,
                      fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
