import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';

import '../models/item_model.dart';
import '../utils/app_utils.dart';
import '../utils/colors.dart';
import '../utils/custom_text_style.dart';
import '../utils/custom_widgets.dart';
import '../widgets/my_navigation_button.dart';
import '../widgets/my_snack_message.dart';



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
                            CustomWidgets.InfoChip(
                              FontAwesomeIcons.layerGroup,
                              'Qty: ${item.quantity}',
                            ),
                            CustomWidgets.InfoChip(
                              FontAwesomeIcons.tag,
                              item.categoryType,
                            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /// --- appbar --- /// 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MyNavigationButton(
            btnIcon: Icons.arrow_back_ios_rounded,
            btnBackground: Colors.black12,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          "Notifications",
          style: myTextStyle18(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: myTextStyle18(),
          tabs:  [Tab(text: 'Expiring Soon'), Tab(text: 'Expired')],
          labelColor: AppColors.main,

          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.main,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildItemsList(isExpired: false),
          _buildItemsList(isExpired: true),
        ],
      ),
    );
  }

  Widget _buildItemsList({required bool isExpired}) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Item>('items').listenable(),
      builder: (context, Box<Item> box, _) {
        final items =
            box.values
                .where((item) {
                  final daysLeft = AppUtils.getDaysLeft(item.expiryDate);
                  return isExpired
                      ? daysLeft < 0
                      : daysLeft >= 0 && daysLeft <= 2;
                })
                .toList()
                .reversed
                .toList();
        return items.isEmpty
            ? Center(
              child:  isExpired ?  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.basketShopping , size: 100, color: Colors.red.shade100,),
                  SizedBox(height: 10,),
                  Text(
                   'No expired items',
                    style: myTextStyle18(fontColor: Colors.black54),
                  ),
                ],
              ) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.basketShopping , size: 100, color: Colors.yellow.shade100,),
                  SizedBox(height: 10,),
                  Text(
                    'No expire soon items',
                    style: myTextStyle18(fontColor: Colors.black54),
                  ),
                ],
              ),
            )
            : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return notificationItemCard(items[index], box, isExpired);
              },
            );
      },
    );
  }
}
