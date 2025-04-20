import 'package:flutter/material.dart';
import 'package:smartstock/constant/app_constant.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/screen/category_items_screen.dart';
import 'package:smartstock/utils/custom_text_style.dart';

class GroceryScreen extends StatelessWidget {
  GroceryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final mqHeight = MediaQuery.of(context).size.height;
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 11,
        childAspectRatio: 2/2.2,
      ),
      itemCount: AppConstant.items.length,
      itemBuilder: (context, index) {
        final grocery = AppConstant.items[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CategoryItemsScreen(
                      categoryType: 'Grocery',
                      itemType: grocery['title'],
                    ),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(21),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  grocery['image'],
                  width: mqHeight * 0.12,
                  color: AppColors.main,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                grocery['title'],
                style: myTextStyle18(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

            ],
          ),
        );
      },
    );
  }
}
