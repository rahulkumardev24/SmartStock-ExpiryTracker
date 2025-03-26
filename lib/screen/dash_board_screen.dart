import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/models/item_model.dart';
import 'package:smartstock/screen/add_item_screen.dart';
import 'package:smartstock/screen/home_screen.dart';
import 'package:smartstock/screen/list_screen.dart';
import 'package:smartstock/screen/notification_screen.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';
import 'package:smartstock/widgets/notification_badge.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectedIndex = 0;

  /// List of Screens
  final List<Widget> _screens = [HomeScreen(), ListScreen()];

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
            /// Items Tab
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

            /// list Tab
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.listCheck,
                    color: _selectedIndex == 1 ? Colors.green : Colors.black54,
                  ),
                  Text(
                    "List",
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
