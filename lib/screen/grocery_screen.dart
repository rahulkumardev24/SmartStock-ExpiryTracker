import 'package:flutter/material.dart';
import 'package:smartstock/constant/app_constant.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {

  @override
  Widget build(BuildContext context) {
    final mqHeight = MediaQuery.of(context).size.height;
    final mqWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: AppColors.primary,
      backgroundColor: Colors.white,
      body: GridView.builder(
        itemCount: AppConstant.items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 11,
          crossAxisSpacing: 11,
        ),
        itemBuilder: (context, index) {
          var item = AppConstant.items[index];
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
                    item['image'],
                    height: mqHeight * 0.10, color: AppColors.main,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 4,),
              Text(item['title'], style: myTextStyle18()),
            ],
          );
        },
      ),
    );
  }
}
