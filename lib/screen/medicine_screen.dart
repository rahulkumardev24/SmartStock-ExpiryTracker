import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/screen/category_items_screen.dart';

class MedicineScreen extends StatelessWidget {
  MedicineScreen({super.key});

  final List<Map<String, dynamic>> medicineCategories = [
    {
      'type': 'Tablets',
      'icon': FontAwesomeIcons.pills,
      'description': 'Pills and tablets'
    },
    {
      'type': 'Syrups',
      'icon': FontAwesomeIcons.prescriptionBottleMedical,
      'description': 'Liquid medicines'
    },
    {
      'type': 'Capsules',
      'icon': FontAwesomeIcons.capsules,
      'description': 'Medicine capsules'
    },
    {
      'type': 'Injections',
      'icon': FontAwesomeIcons.syringe,
      'description': 'Injectable medicines'
    },
    {
      'type': 'Drops',
      'icon': FontAwesomeIcons.droplet,
      'description': 'Eye and ear drops'
    },
    {
      'type': 'Ointments',
      'icon': FontAwesomeIcons.cube,
      'description': 'Creams and ointments'
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
      itemCount: medicineCategories.length,
      itemBuilder: (context, index) {
        final category = medicineCategories[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryItemsScreen(
                  categoryType: 'Medicine',
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
