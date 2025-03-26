import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartstock/models/item_model.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';
import 'package:smartstock/widgets/expiry_indicator.dart';
import 'package:smartstock/widgets/my_filled_button.dart';
import 'package:smartstock/widgets/my_navigation_button.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/screen/add_item_screen.dart';
import 'package:smartstock/widgets/my_outline_button.dart';

class CategoryItemsScreen extends StatelessWidget {
  final String categoryType;
  final String itemType;

  const CategoryItemsScreen({
    super.key,
    required this.categoryType,
    required this.itemType,
  });

 /// check how many day left
  int _getDaysLeft(String expiryDate) {
    try {
      final expiry = DateFormat('dd MMM yyyy').parse(expiryDate);
      // Set both times to start of day for accurate comparison
      final now = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      final expiryDay = expiry.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      return expiryDay.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }


  /// delete alert
  Future<bool> _confirmDelete(BuildContext context, String itemName) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Confirm Delete' , style: myTextStyle18(fontWeight: FontWeight.bold),),
          content: Text('Are you sure you want to delete "$itemName"?' , style: myTextStyle12(),),
          backgroundColor: AppColors.primary,
          actions: [
            MyOutlineButton(
              onPressed: () => Navigator.of(context).pop(false),
              btnText: 'Cancel',
              borderColor: Colors.black45,
              borderRadius: 21,
              btnTextColor:Colors.black45 ,
              btnBackground: Colors.transparent,

            ),
            MyFilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              btnText: 'Delete',
              btnTextColor: Colors.white,
              btnBackground: Colors.red,
              borderRadius: 21,

            ),
          ],
        );
      },
    ) ?? false;
  }

  Widget _buildItemCard(Item item, Box<Item> box, BuildContext context) {
    return Dismissible(
      key: ValueKey(item.key),
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const FaIcon(
          FontAwesomeIcons.trash,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _confirmDelete(context, item.itemName),
      onDismissed: (direction) {
        box.deleteAt(box.values.toList().indexOf(item));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.itemName} deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                box.add(item);
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: item.imagePath != null && item.imagePath!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(item.imagePath!),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.main.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FaIcon(
                            item.categoryType.toLowerCase() == 'grocery'
                                ? FontAwesomeIcons.box
                                : FontAwesomeIcons.capsules,
                            color: AppColors.main,
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.main.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      item.categoryType.toLowerCase() == 'grocery'
                          ? FontAwesomeIcons.box
                          : FontAwesomeIcons.capsules,
                      color: AppColors.main,
                    ),
                  ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    item.itemName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildExpiryBadge(item.expiryDate),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      FontAwesomeIcons.layerGroup,
                      'Qty: ${item.quantity}',
                    ),
                    _buildInfoChip(
                      FontAwesomeIcons.tag,
                      item.categoryType,
                    ),
                    _buildInfoChip(
                      FontAwesomeIcons.calendar,
                      'Expires: ${item.expiryDate}',
                      isExpiringSoon: _isExpiringSoon(item.expiryDate),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ExpiryIndicator(expiryDate: item.expiryDate),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {bool isExpiringSoon = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isExpiringSoon ? Colors.orange.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            icon,
            size: 12,
            color: isExpiringSoon ? Colors.orange : Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isExpiringSoon ? Colors.orange : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiryBadge(String expiryDate) {
    final daysLeft = _getDaysLeft(expiryDate);
    
    if (daysLeft < 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.circleXmark,
              color: Colors.red,
              size: 12,
            ),
            const SizedBox(width: 4),
            const Text(
              'Expired',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else if (daysLeft == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.orange,
              size: 12,
            ),
            const SizedBox(width: 4),
            const Text(
              'Expires Today',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else if (daysLeft == 1) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.orange,
              size: 12,
            ),
            const SizedBox(width: 4),
            const Text(
              'Expires Tomorrow',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  bool _isExpiringSoon(String expiryDate) {
    final daysLeft = _getDaysLeft(expiryDate);
    return daysLeft >= 0 && daysLeft <= 30;
  }

  @override
  Widget build(BuildContext context) {
    final mqHeight = MediaQuery.of(context).size.height;
    final mqWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      /// ----- App bar ---- ///
      appBar: AppBar(
        title: Text(
          '$itemType Items',
          style: myTextStyle18(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyNavigationButton(
            btnIcon: Icons.arrow_back_ios_new_rounded,
            btnBackground: Colors.black12,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,

      /// add item floating action button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddItemScreen(
                    prefilledCategory: categoryType,
                    prefilledItemType: itemType,
                  ),
            ),
          );
        },
        backgroundColor: AppColors.main,
        heroTag: 'add_${categoryType}_$itemType',
        label: Text("Add item" , style: myTextStyle18(fontColor: Colors.white),),
        foregroundColor: Colors.white,
        icon: const FaIcon(FontAwesomeIcons.plus),
        elevation: 0,
      ),

      /// --- Body --- ///
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Item>('items').listenable(),
        builder: (context, Box<Item> box, _) {
          /// get final item according to title
          final items = box.values.where((item) =>
                        item.categoryType.toLowerCase() == categoryType.toLowerCase() &&
                        item.itemType.toLowerCase() == itemType.toLowerCase(),
                  )
                  .toList();
          /// if empty
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
                    color: AppColors.main.withAlpha(100),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No $itemType items added yet',
                    style: myTextStyle18(
                      fontColor: AppColors.main.withAlpha(100),
                    ),
                  ),
                  Text(
                    'Click on the Add Item button to track your item\'s expiry',
                    style: myTextStyle12(
                      fontColor:Colors.black45,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            );
          }

          /// --- if data --- ///
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildItemCard(item, box, context);
            },
          );
        },
      ),
    );
  }
}
