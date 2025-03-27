import 'package:flutter/material.dart';
import 'package:smartstock/screen/grocery_screen.dart';
import 'package:smartstock/screen/medicine_screen.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _selectedIndex = 0;

  /// Function to return the selected screen
  Widget _getSelectedScreen() {
    return _selectedIndex == 0 ?  GroceryScreen() :  MedicineScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            /// Scrollable AppBar
            SliverAppBar(
              elevation: 0,
              expandedHeight: 100.0,
              backgroundColor: AppColors.primary,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 12),

                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Eat fresh everyday",
                      style: myTextStyle18(),
                    ),
                    Text(
                      "Track expiry dates before it's too late",
                      style: myTextStyle12(),
                    ),
                  ],
                ),

              ),
            ),

            /// Sticky Category Buttons
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeader(
                child: Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _categoryButton("Grocery", 0),
                      _categoryButton("Medicine", 1),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },

        /// Animated Screen Switching
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (widget, animation) =>
              FadeTransition(opacity: animation, child: widget),
          child: _getSelectedScreen(),
        ),
      ),
    );
  }

  /// Custom Category Button
  Widget _categoryButton(String title, int index) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedIndex == index ? AppColors.main : Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        title,
        style: myTextStyle18(
          fontWeight: FontWeight.bold,
          fontColor: _selectedIndex == index ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}

/// Sticky Header Delegate for Tabs
class _StickyHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyHeader({required this.child});
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: Colors.white,
      child: child,
    );
  }
  @override
  double get maxExtent => 70;
  @override
  double get minExtent => 70;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
