import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/models/item_model.dart';
import 'package:smartstock/screen/notification_screen.dart';
import 'package:smartstock/utils/app_utils.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';
import 'package:smartstock/widgets/my_list_card.dart';
import 'package:smartstock/widgets/my_navigation_button.dart';
import 'package:smartstock/widgets/notification_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// here we create function for greeting
  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 20) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  int _getExpiringItemsCount() {
    final box = Hive.box<Item>('items');
    return box.values.where((item) {
      try {
        final expiry = DateFormat('dd MMM yyyy').parse(item.expiryDate);
        final now = DateTime.now();
        final difference = expiry.difference(now).inDays;
        return difference <= 2 && difference >= 0;
      } catch (e) {
        return false;
      }
    }).length;
  }


  @override
  Widget build(BuildContext context) {
    final mqWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,

      /// --- APP BAR --- ///
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getGreeting(), style: myTextStyle12()),
            Text(
              "Rahul kumar Sahu ",
              style: myTextStyle18(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: Hive.box<Item>('items').listenable(),
            builder: (context, box, _) {
              final count = _getExpiringItemsCount();
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: mqWidth * 0.11,
                    height: mqWidth * 0.11,
                    child: MyNavigationButton(
                      btnIcon: FontAwesomeIcons.bell,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      },
                      iconSize: 21,
                      btnRadius: 100,
                      btnBackground: AppColors.primary,
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: NotificationBadge(count: count),
                    ),
                ],
              );
            },
          ),
          SizedBox(width: 12),
        ],
        backgroundColor: Colors.white,
      ),

      /// ---- BODY ---- ///
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Item>('items').listenable(),
        builder: (context, Box<Item> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.boxOpen,
                    size: 64,
                    color: AppColors.main.withAlpha(100),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No items added yet',
                    style: myTextStyle18(
                      fontColor: AppColors.main.withAlpha(100),
                    ),
                  ),
                  Text(
                    'Click on the Add Item button to get started',
                    style: myTextStyle12(
                      fontColor: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          final items = box.values.toList();
          items.sort((a, b) {
            final daysLeftA = AppUtils.getDaysLeft(a.expiryDate);
            final daysLeftB = AppUtils.getDaysLeft(b.expiryDate);

            /// Put today/tomorrow items first
            if ((daysLeftA == 0 || daysLeftA == 1) &&
                (daysLeftB != 0 && daysLeftB != 1)) {
              return -1;
            }
            if ((daysLeftB == 0 || daysLeftB == 1) &&
                (daysLeftA != 0 && daysLeftA != 1)) {
              return 1;
            }

            // For other items, sort by expiry date
            return daysLeftA.compareTo(daysLeftB);
          });
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return MyListCard(item: item, box: box);
            },
          );
        },
      ),
    );
  }
}
