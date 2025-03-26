import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/models/item_model.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';
import 'dart:io';

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
      // Set both times to start of day for accurate comparison
      final now = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      final expiryDay = expiry.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      return expiryDay.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }

  String _getExpiryText(String expiryDate) {
    final daysLeft = _getDaysLeft(expiryDate);
    if (daysLeft < 0) {
      return 'Expired';
    } else if (daysLeft == 0) {
      return 'Expires Today';
    } else if (daysLeft == 1) {
      return 'Expires Tomorrow';
    } else {
      return 'Expires in $daysLeft days';
    }
  }

  Color _getExpiryColor(int daysLeft) {
    if (daysLeft < 0) {
      return Colors.red;
    } else if (daysLeft <= 1) {
      return Colors.orange;
    } else {
      return Colors.orange;
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Expiring Soon'),
            Tab(text: 'Expired'),
          ],
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
        final items = box.values.where((item) {
          final daysLeft = _getDaysLeft(item.expiryDate);
          if (isExpired) {
            return daysLeft < 0;
          } else {
            return daysLeft >= 0 && daysLeft <= 1; // Show only today and tomorrow
          }
        }).toList();

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  isExpired ? FontAwesomeIcons.check : FontAwesomeIcons.bell,
                  size: 64,
                  color: AppColors.main.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  isExpired
                      ? 'No expired items'
                      : 'No items expiring soon',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.main.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        // Sort items by expiry date
        items.sort((a, b) {
          final daysLeftA = _getDaysLeft(a.expiryDate);
          final daysLeftB = _getDaysLeft(b.expiryDate);
          return daysLeftA.compareTo(daysLeftB);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final daysLeft = _getDaysLeft(item.expiryDate);
            final expiryColor = _getExpiryColor(daysLeft);

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: expiryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: expiryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    item.categoryType.toLowerCase() == 'grocery'
                        ? Icons.shopping_basket_outlined
                        : Icons.medical_services_outlined,
                    color: expiryColor,
                  ),
                ),
                title: Text(
                  item.itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Category: ${item.categoryType} - ${item.itemType}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Quantity: ${item.quantity}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: expiryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: expiryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                daysLeft < 0
                                    ? Icons.error_outline
                                    : Icons.access_time,
                                size: 12,
                                color: expiryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getExpiryText(item.expiryDate),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: expiryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.trash,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    box.delete(item.key);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.itemName} deleted'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
