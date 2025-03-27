import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartstock/screen/add_item_screen.dart';
import 'package:smartstock/screen/category_screen.dart';
import 'package:smartstock/screen/home_screen.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;

  /// List of Screens
  final List<Widget> _screens = [HomeScreen() , CategoryScreen(), ];

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
      body: _screens[_selectedIndex],

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
        shape: CircleBorder(),
        child: FaIcon(FontAwesomeIcons.plus, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      /// Custom Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        height: mqHeight * 0.09,
        shape: CircularNotchedRectangle(),
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
                      fontColor:
                          _selectedIndex == 0 ? Colors.green : Colors.black54,
                      fontWeight:
                          _selectedIndex == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            /// Add Item (Centered)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20), // Space to align with FAB
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
                      fontColor:
                          _selectedIndex == 1 ? Colors.green : Colors.black54,
                      fontWeight:
                          _selectedIndex == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
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
