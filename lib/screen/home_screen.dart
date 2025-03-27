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
import 'package:smartstock/widgets/search_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  bool isSearchOpen = false;
  List<Item> filteredItems = [];

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

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterItems);
    searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = searchController.text.toLowerCase();
    final box = Hive.box<Item>('items');

    setState(() {
      filteredItems =
          box.values.where((item) {
            return item.itemName.toLowerCase().contains(query) ||
                item.categoryType.toLowerCase().contains(query) ||
                item.expiryDate.toLowerCase().contains(query);
          }).toList();
    });
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

      /// ---- APP BAR ---- ///
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getGreeting(), style: myTextStyle12()),
            Text(
              "Rahul Kumar Sahu",
              style: myTextStyle18(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: mqWidth * 0.11,
            height: mqWidth * 0.11,
            child: MyNavigationButton(
              btnIcon:
                  isSearchOpen
                      ? FontAwesomeIcons.xmark
                      : FontAwesomeIcons.magnifyingGlass,
              onPressed: () {
                setState(() {
                  isSearchOpen = !isSearchOpen;
                  if (!isSearchOpen) {
                    searchController.clear();
                  }
                });
              },
              iconSize: 21,
              btnRadius: 100,
              btnBackground: Colors.black12.withAlpha(20),
            ),
          ),
          SizedBox(width: 12),
          SizedBox(width: 12),
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
      body: Column(
        children: [
          if (isSearchOpen)
            SearchBox(
              controller: searchController,
              onSearch: (query) {
                _filterItems();
              },
            ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Item>('items').listenable(),
              builder: (context, Box<Item> box, _) {
                final itemsToShow =
                    searchController.text.isEmpty
                        ? box.values.toList().reversed.toList()
                        : filteredItems.reversed.toList();
                if (itemsToShow.isEmpty) {
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
                          'No items found',
                          style: myTextStyle18(
                            fontColor: AppColors.main.withAlpha(100),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: itemsToShow.length,
                  itemBuilder: (context, index) {
                    final item = itemsToShow[index];
                    return MyListCard(item: item, box: box);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
