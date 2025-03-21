import 'package:flutter/material.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicalScreenState();
}

class _MedicalScreenState extends State<MedicineScreen> {
  List<Map<String, dynamic>> items = [
    {"image": "assets/images/medicine (1).png", "title": "Medicines"},
    {"image": "assets/images/syrup.png", "title": "Syrups"},
    {"image": "assets/images/medical.png", "title": "Injections"},
    {"image": "assets/images/bandage.png", "title": "First Aid"},
    {"image": "assets/images/medical (1).png", "title": "Thermometers"},
    {"image": "assets/images/mask.png", "title": "Face Masks"},
    {"image": "assets/images/gloves.png", "title": "Gloves"},
    {"image": "assets/images/hand-soap.png", "title": "Sanitizers"},
    {"image": "assets/images/eye-dropper.png", "title": "Eye Drops"},
  ];

  @override
  Widget build(BuildContext context) {
    final mqHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GridView.builder(
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 11,
          crossAxisSpacing: 11,
        ),
        itemBuilder: (context, index) {
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
                    items[index]['image'],
                    height: mqHeight * 0.10,
                    color: AppColors.main,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(items[index]['title'], style: myTextStyle18()),
            ],
          );
        },
      ),
    );
  }
}
