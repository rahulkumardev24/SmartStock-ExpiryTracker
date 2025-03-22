import 'package:flutter/material.dart';
import 'package:smartstock/constant/app_constant.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicalScreenState();
}

class _MedicalScreenState extends State<MedicineScreen> {
  @override
  Widget build(BuildContext context) {
    final mqHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GridView.builder(
        itemCount: AppConstant.itemsMed.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 11,
          crossAxisSpacing: 11,
        ),
        itemBuilder: (context, index) {
          var itemMedicine = AppConstant.itemsMed[index];
          return Column(
            children: [
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: const [
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
                    itemMedicine['image'],
                    height: mqHeight * 0.10,
                    color: AppColors.main,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(itemMedicine['title'], style: myTextStyle18()),
            ],
          );
        },
      ),
    );
  }
}
