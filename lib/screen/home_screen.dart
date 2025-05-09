import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/item_model.dart';
import '../utils/colors.dart';
import '../utils/custom_text_style.dart';
import '../widgets/my_list_card.dart';
import '../widgets/my_navigation_button.dart';
import '../widgets/notification_badge.dart';
import '../widgets/search_box.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  String userName;
  HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  bool isSearchOpen = false;
  bool isShort = false;
  final itemCount = Hive.box<Item>('items');
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
    final mqHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,

      /// ---- APP BAR ---- ///
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getGreeting(), style: myTextStyle12()),
            Text(
              widget.userName,
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

          ValueListenableBuilder(
            valueListenable: Hive.box<Item>('items').listenable(),
            builder: (context, box, _) {
              final count = _getExpiringItemsCount();
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  /// --- notification button --- ///
                  SizedBox(
                    width: mqWidth * 0.11,
                    height: mqWidth * 0.11,
                    child: MyNavigationButton(
                      heorTag: 100,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isSearchOpen)
              SearchBox(
                controller: searchController,
                onSearch: (query) {
                  _filterItems();
                },
              ),

            /// poster
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 12,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(21),
                    child: Image.asset(
                      "assets/images/poster.jpg",
                      fit: BoxFit.cover,
                      height: mqHeight * 0.15,
                      width: mqWidth,
                    ),
                  ),
                  Positioned(
                    left: mqWidth * 0.05,
                    child: SizedBox(
                      height: mqHeight * 0.15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Eat Fresh",
                            style: TextStyle(
                              fontFamily: "secondary",
                              fontSize: mqHeight * 0.025,
                            ),
                          ),
                          Text("and", style: myTextStyle18()),
                          Text(
                            "Feel Fresh",
                            style: TextStyle(
                              fontFamily: "secondary",
                              fontSize: mqHeight * 0.025,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// all items row
            "${Hive.box<Item>('items').length}".isEmpty
                ? SizedBox()
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// --- All items --- ///
                      Row(
                        children: [
                          Text("All items", style: myTextStyle18()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  searchController.text.isNotEmpty
                                      ? "${filteredItems.length}"
                                      : "${Hive.box<Item>('items').length}",
                                  style: myTextStyle15(
                                    fontColor: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      /// --- short button --- ///
                      InkWell(
                        onTap: () {
                          setState(() {
                            isShort = !isShort;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isShort
                                    ? AppColors.main.withAlpha(100)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: AppColors.main),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              "assets/icons/sort.png",
                              height: 21,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ValueListenableBuilder(
              valueListenable: Hive.box<Item>('items').listenable(),
              builder: (context, Box<Item> box, _) {
                final itemsToShow =
                    searchController.text.isEmpty
                        ? (isShort
                            ? box.values.toList()
                            : box.values.toList().reversed.toList())
                        : (!isShort
                            ? filteredItems.toList()
                            : filteredItems.reversed.toList());
                if (itemsToShow.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: mqHeight * 0.2),
                        FaIcon(
                          FontAwesomeIcons.boxOpen,
                          size: 64,
                          color: AppColors.main.withAlpha(100),
                        ),

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
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: itemsToShow.length,
                  itemBuilder: (context, index) {
                    final item = itemsToShow[index];
                    return MyListCard(item: item, box: box);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
