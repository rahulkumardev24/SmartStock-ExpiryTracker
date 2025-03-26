import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  final String itemName;

  @HiveField(1)
  final String quantity;

  @HiveField(2)
  final String purchaseDate;

  @HiveField(3)
  final String expiryDate;

  @HiveField(4)
  final String? imagePath;

  @HiveField(5)
  final String categoryType;

  @HiveField(6)
  final String itemType;

  Item({
    required this.itemName,
    required this.quantity,
    required this.purchaseDate,
    required this.expiryDate,
    this.imagePath,
    required this.categoryType,
    required this.itemType,
  });
}
