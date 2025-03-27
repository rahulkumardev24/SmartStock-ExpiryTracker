import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartstock/models/item_model.dart';
import 'package:smartstock/utils/app_utils.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';
import 'package:smartstock/utils/custom_widgets.dart';
import 'dart:io';

import 'package:smartstock/widgets/my_navigation_button.dart';
import 'package:smartstock/widgets/my_snack_message.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _getDaysLeft(String expiryDate) {
    try {
      final expiry = DateFormat('dd MMM yyyy').parse(expiryDate);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Notifications",
          style: myTextStyle18(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyNavigationButton(
            btnIcon: Icons.arrow_back_ios_new_outlined,
            btnBackground: Colors.black12,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Expiring Soon'), Tab(text: 'Expired')],
          labelColor: AppColors.main,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.main,
          labelStyle: myTextStyle18(),
          dividerHeight: 0,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          /// for expiry soon
          tabList(isExpired: false),

          /// for expired
          tabList(isExpired: true),
        ],
      ),
    );
  }

  Widget tabList({required bool isExpired}) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Item>('items').listenable(),
      builder: (context, Box<Item> box, _) {
        final items =
            box.values.where((item) {
              final daysLeft = _getDaysLeft(item.expiryDate);
              if (isExpired) {
                return daysLeft < 0;
              } else {
                return daysLeft >= 0 && daysLeft <= 7;
              }
            }).toList();

        /// if empty
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  isExpired
                      ? FontAwesomeIcons.circleCheck
                      : FontAwesomeIcons.bell,
                  size: 64,
                  color: AppColors.main.withAlpha(100),
                ),
                const SizedBox(height: 16),
                Text(
                  isExpired ? 'No expired items' : 'No items expiring soon',
                  style: myTextStyle18(
                    fontColor: AppColors.main.withAlpha(100),
                  ),
                ),
              ],
            ),
          );
        }

        /// if data
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return notificationItemCard(item, box, isExpired);
          },
        );
      },
    );
  }

  Widget InfoChip(IconData icon, String text, {bool isExpiringSoon = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FaIcon(icon, size: 12, color: Colors.black.withAlpha(170)),
          const SizedBox(width: 4),
          Text(
            text,
            style: myTextStyle12(fontColor: Colors.black.withAlpha(170)),
          ),
        ],
      ),
    );
  }

  Widget notificationItemCard(Item item, Box<Item> box, bool isExpired) {
    return InkWell(
      onLongPress: () async {
        if (await AppUtils.confirmDelete(context, item.itemName)) {
          box.deleteAt(box.values.toList().indexOf(item));
          MySnackMessage(
            message: '${item.itemName} deleted',
            backgroundColor: Colors.red.shade400,
            actionLabel: "Undo",
            labelTextColor: Colors.black87,
            onActionPressed: () {
              box.add(item);
            },
          ).show(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color:
              isExpired
                  ? Colors.red.shade100.withAlpha(100)
                  : (isExpired == false
                      ? Colors.orange.shade100.withAlpha(100)
                      : Color(0xff80BCBD).withAlpha(50)),

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
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
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
                        size: MediaQuery.of(context).size.width * 0.15,
                      ),
                    ),
                  ),
                ),

            /// --- Details --- ///
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          /// item name
                          child: Text(item.itemName, style: myTextStyle15()),
                        ),
                        CustomWidgets.expiryBadge(item.expiryDate),
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
                            InfoChip(
                              FontAwesomeIcons.layerGroup,
                              'Qty: ${item.quantity}',
                            ),
                            InfoChip(FontAwesomeIcons.tag, item.categoryType),
                          ],
                        ),
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
}
