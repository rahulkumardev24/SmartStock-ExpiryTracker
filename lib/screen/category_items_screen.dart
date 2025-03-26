import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartstock/models/item_model.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/screen/add_item_screen.dart';

class CategoryItemsScreen extends StatelessWidget {
  final String categoryType;
  final String itemType;
  
  const CategoryItemsScreen({
    super.key,
    required this.categoryType,
    required this.itemType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$itemType Items',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItemScreen(
                prefilledCategory: categoryType,
                prefilledItemType: itemType,
              ),
            ),
          );
        },
        backgroundColor: AppColors.main,
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Item>('items').listenable(),
        builder: (context, Box<Item> box, _) {
          final items = box.values.where((item) => 
            item.categoryType.toLowerCase() == categoryType.toLowerCase() &&
            item.itemType.toLowerCase() == itemType.toLowerCase()
          ).toList();

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    categoryType.toLowerCase() == 'grocery' 
                        ? FontAwesomeIcons.basketShopping
                        : FontAwesomeIcons.pills,
                    size: 64,
                    color: AppColors.main.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No $itemType items found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.main.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                key: Key(item.itemName),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const FaIcon(
                    FontAwesomeIcons.trash,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  box.delete(item.key);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.itemName} deleted'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.main.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FaIcon(
                        categoryType.toLowerCase() == 'grocery'
                            ? FontAwesomeIcons.box
                            : FontAwesomeIcons.capsules,
                        color: AppColors.main,
                      ),
                    ),
                    title: Text(
                      item.itemName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Quantity: ${item.quantity}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Expires: ${item.expiryDate}',
                          style: TextStyle(
                            color: _isExpiringSoon(item.expiryDate)
                                ? Colors.red
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool _isExpiringSoon(String expiryDate) {
    try {
      final expiry = DateFormat('dd MMM yyyy').parse(expiryDate);
      final now = DateTime.now();
      final difference = expiry.difference(now).inDays;
      return difference <= 30 && difference >= 0;
    } catch (e) {
      return false;
    }
  }
}
