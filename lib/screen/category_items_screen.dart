import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartstock/models/item_model.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';
import 'package:smartstock/widgets/my_list_card.dart';
import 'package:smartstock/widgets/my_navigation_button.dart';
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
              return MyListCard(item: item, box: box,) ;
            },
          );
        },
      ),
    );
  }
}
