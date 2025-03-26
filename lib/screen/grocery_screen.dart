import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/screen/category_items_screen.dart';

class GroceryScreen extends StatelessWidget {
   GroceryScreen({super.key});

  final List<Map<String, dynamic>> groceryCategories = [
    {
      'type': 'Fruits',
      'icon': FontAwesomeIcons.apple,
      'description': 'Fresh fruits and berries'
    },
    {
      'type': 'Vegetables',
      'icon': FontAwesomeIcons.carrot,
      'description': 'Fresh vegetables'
    },
    {
      'type': 'Dairy',
      'icon': FontAwesomeIcons.cheese,
      'description': 'Milk, cheese, and dairy products'
    },
    {
      'type': 'Beverages',
      'icon': FontAwesomeIcons.wineBottle,
      'description': 'Drinks and beverages'
    },
    {
      'type': 'Snacks',
      'icon': FontAwesomeIcons.cookieBite,
      'description': 'Snacks and chips'
    },
    {
      'type': 'Grains',
      'icon': FontAwesomeIcons.breadSlice,
      'description': 'Rice, wheat, and cereals'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: groceryCategories.length,
      itemBuilder: (context, index) {
        final category = groceryCategories[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryItemsScreen(
                  categoryType: 'Grocery',
                  itemType: category['type'],
                ),
              ),
            );
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.main.withOpacity(0.1),
                    AppColors.main.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FaIcon(
                      category['icon'],
                      color: AppColors.main,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    category['type'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['description'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
