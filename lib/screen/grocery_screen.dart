import 'package:flutter/material.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  List<Map<String, dynamic>> items = [
    {"image": "assets/images/fruits.png", "title": "Fruits"},
    {"image": "assets/images/vegetable.png", "title": "Vegetables"},
    {"image": "assets/images/cupcake.png", "title": "Sweets"},
    {"image": "assets/images/milk.png", "title": "Dairy Products"},
    {"image": "assets/images/bakery.png", "title": "Bakery"},
    {"image": "assets/images/candies.png", "title": "Snacks"},
    {"image": "assets/images/chicken-leg.png", "title": "Meat & Poultry"},
    {"image": "assets/images/seafood.png", "title": "Seafood"},
    {"image": "assets/images/frozen-food.png", "title": "Frozen Foods"},
    {"image": "assets/images/spices.png", "title": "Spices"},
    {"image": "assets/images/pouring.png", "title": "Cooking Oils"},
    {"image": "assets/images/pet-supplies.png", "title": "Pet Supplies"},
  ];

  @override
  Widget build(BuildContext context) {
    final mqHeight = MediaQuery.of(context).size.height;
    final mqWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: AppColors.primary,
      backgroundColor: Colors.white,
      body: GridView.builder(
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 11,
          crossAxisSpacing: 11,
        ),
        itemBuilder: (context, index) {
          return Column(
            children: [
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: AppColors.primary,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 7,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(21.0),
                  child: Image.asset(
                    items[index]['image'],
                    height: mqHeight * 0.10, color: AppColors.main,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 4,),
              Text(items[index]['title'], style: myTextStyle18()),
            ],
          );
        },
      ),
    );
  }
}
