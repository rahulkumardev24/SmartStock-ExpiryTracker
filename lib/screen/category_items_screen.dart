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
import 'package:smartstock/widgets/my_snack_message.dart';

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
      final now = DateTime.now().copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      final expiryDay = expiry.copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
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
              title: Text(
                'Confirm Delete',
                style: myTextStyle18(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Are you sure you want to delete "$itemName"?',
                style: myTextStyle12(),
              ),
              backgroundColor: AppColors.primary,
              actions: [
                MyOutlineButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  btnText: 'Cancel',
                  borderColor: Colors.black45,
                  borderRadius: 21,
                  btnTextColor: Colors.black45,
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
        ) ??
        false;
  }

  /// item card
  Widget _buildItemCard(Item item, Box<Item> box, BuildContext context) {
    return Dismissible(
      key: ValueKey(item.key),
      /// delete operation
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const FaIcon(FontAwesomeIcons.trash, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _confirmDelete(context, item.itemName),
      onDismissed: (direction) {
        box.deleteAt(box.values.toList().indexOf(item));
        MySnackMessage(
          message: '${item.itemName} deleted successfully',
          fontWeight: FontWeight.bold,
          actionLabel: "Undo",
          backgroundColor: Colors.green.shade300,
          onActionPressed: () {
            box.add(item);
          },
        ).show(context);
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.main.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
          /// Item Image
          item.imagePath != null && item.imagePath!.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                File(item.imagePath!),
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                fit: BoxFit.cover,
                            ),
                          ),
              )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                color: AppColors.main.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: FaIcon(
                                item.categoryType.toLowerCase() == 'grocery'
                                                  ? FontAwesomeIcons.basketShopping
                                                  : FontAwesomeIcons.capsules,
                                              color: AppColors.main,
                                size: MediaQuery.of(context).size.width * 0.2,

                              ),
                            ),
                          ),
              ),
            /// --- Details --- ///
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  children: [
                    Row(
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
                    ) ,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            /// icon chip call
                            _buildInfoChip(
                              FontAwesomeIcons.layerGroup,
                              'Qty: ${item.quantity}',
                            ),
                            _buildInfoChip(FontAwesomeIcons.tag, item.categoryType),
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
                  ],
                ),
              ),
            )

        ],)
      ),
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String label, {
    bool isExpiringSoon = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isExpiringSoon ? Colors.orange.withAlpha(40) : Colors.white60,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            icon,
            size: 12,
            color: isExpiringSoon ? Colors.orange : Colors.black.withAlpha(170),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: myTextStyle12(fontColor:isExpiringSoon ? Colors.orange : Colors.black.withAlpha(170)),

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
          color: Colors.red.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withAlpha(80)),
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
             Text(
              'Expired',
              style: myTextStyle12(fontColor: Colors.red , fontWeight: FontWeight.bold)
              ),

          ],
        ),
      );
    } else if (daysLeft == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withAlpha(80)),
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
             Text(
              'Expires Today',
              style: myTextStyle12(fontColor: Colors.orange , fontWeight: FontWeight.bold)
            ),
          ],
        ),
      );
    } else if (daysLeft == 1) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withAlpha(80)),
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
             Text(
              'Expires Tomorrow',
              style:myTextStyle12(fontWeight: FontWeight.bold , fontColor: Colors.orange) ,
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
          itemType,
          style: myTextStyle24(fontWeight: FontWeight.bold),
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
        label: Text("Add item", style: myTextStyle18(fontColor: Colors.white)),
        foregroundColor: Colors.white,
        icon: const FaIcon(FontAwesomeIcons.plus),
        elevation: 0,
      ),

      /// --- Body --- ///
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Item>('items').listenable(),
        builder: (context, Box<Item> box, _) {
          /// get final item according to title
          final items =
              box.values
                  .where(
                    (item) =>
                        item.categoryType.toLowerCase() ==
                            categoryType.toLowerCase() &&
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
                      fontColor: Colors.black45,
                      fontWeight: FontWeight.bold,
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
