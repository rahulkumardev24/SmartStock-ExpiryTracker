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
    {"image": "assets/images/medicine.png", "title": "Medicines"},
    {"image": "assets/images/syrup.png", "title": "Syrups"},
    {"image": "assets/images/injection.png", "title": "Injections"},
    {"image": "assets/images/bandage.png", "title": "First Aid"},
    {"image": "assets/images/thermometer.png", "title": "Thermometers"},
    {"image": "assets/images/mask.png", "title": "Face Masks"},
    {"image": "assets/images/gloves.png", "title": "Gloves"},
    {"image": "assets/images/sanitizer.png", "title": "Sanitizers"},
    {"image": "assets/images/vitamins.png", "title": "Vitamins"},
    {"image": "assets/images/pain-relief.png", "title": "Pain Relief"},
    {"image": "assets/images/eye-drops.png", "title": "Eye Drops"},
    {"image": "assets/images/health-monitor.png", "title": "Health Monitors"},
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
                    height: mqHeight * 0.13,
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
