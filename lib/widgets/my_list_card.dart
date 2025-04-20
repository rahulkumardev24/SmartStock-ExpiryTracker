import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartstock/models/item_model.dart';
import 'package:smartstock/utils/custom_text_style.dart';
import 'package:smartstock/widgets/my_snack_message.dart';
import '../utils/app_utils.dart';
import '../utils/custom_widgets.dart';

import '../widgets/expiry_indicator.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyListCard extends StatelessWidget {
  final Item item;
  final Box<Item> box;

  const MyListCard({Key? key, required this.item, required this.box})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      confirmDismiss:
          (direction) => AppUtils.confirmDelete(context, item.itemName),
      onDismissed: (direction) {
        box.deleteAt(box.values.toList().indexOf(item));
        MySnackMessage(
          message: '${item.itemName} deleted successfully',
          fontWeight: FontWeight.bold,
          actionLabel: "Undo",
          backgroundColor: Colors.red.shade400,
          onActionPressed: () {
            box.add(item);
          },
        ).show(context);
      },

      /// main Container
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xff80BCBD).withAlpha(50),
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
                : _buildPlaceholderImage(context),

            /// --- Details --- ///
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Column(
                  children: [
                    /// --- expiry badge --- ///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [CustomWidgets.expiryBadge(item.expiryDate)],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(item.itemName, style: myTextStyle15()),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            /// icon chip call
                            CustomWidgets.InfoChip(
                              FontAwesomeIcons.layerGroup,
                              'Qty: ${item.quantity}',
                            ),
                            CustomWidgets.InfoChip(
                              FontAwesomeIcons.tag,
                              item.categoryType,
                            ),
                            CustomWidgets.InfoChip(
                              FontAwesomeIcons.calendar,
                              'Expires: ${item.expiryDate}',
                              isExpiringSoon: AppUtils.isExpiringSoon(
                                item.expiryDate,
                              ),
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
            ),
          ],
        ),
      ),
    );
  }

  /// Placeholder Image Widget
  Widget _buildPlaceholderImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          color: const Color(0xff80BCBD).withAlpha(50),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: FaIcon(
            item.categoryType.toLowerCase() == 'grocery'
                ? FontAwesomeIcons.basketShopping
                : FontAwesomeIcons.capsules,
            color: const Color(0xff80BCBD),
            size: MediaQuery.of(context).size.width * 0.2,
          ),
        ),
      ),
    );
  }
}
