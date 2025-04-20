import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constant/app_constant.dart';
import '../utils/colors.dart';
import '../utils/custom_text_style.dart';
import 'category_items_screen.dart';

class MedicineScreen extends StatelessWidget {
  MedicineScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final mqHeight = MediaQuery.of(context).size.height;
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2/2.2,
        crossAxisSpacing: 21,
      ),
      itemCount: AppConstant.itemsMed.length,
      itemBuilder: (context, index) {
        final medicine = AppConstant.itemsMed[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryItemsScreen(
                  categoryType: 'Medicine',
                  itemType: medicine['title'],
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
                  medicine['image'],
                  width: mqHeight * 0.12,
                  color: AppColors.main,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                medicine['title'],
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
