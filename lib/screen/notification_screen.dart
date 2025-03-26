import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartstock/models/item_model.dart';
import 'package:smartstock/utils/colors.dart';
import 'package:smartstock/utils/custom_text_style.dart';
import 'package:smartstock/widgets/expiry_indicator.dart';
import 'dart:io';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
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

  bool _isExpiringSoon(String expiryDate) {
    final daysLeft = _getDaysLeft(expiryDate);
    return daysLeft <= 7;
  }

  Widget _buildInfoChip(IconData icon, String text, {bool isExpiringSoon = false}) {
    return Chip(
      avatar: FaIcon(
        icon,
        size: 16,
        color: isExpiringSoon ? Colors.orange : Colors.grey[600],
      ),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: isExpiringSoon ? Colors.orange : Colors.grey[600],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildExpiryBadge(String expiryDate) {
    final daysLeft = _getDaysLeft(expiryDate);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: daysLeft < 0 ? Colors.red : daysLeft <= 1 ? Colors.orange : Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getExpiryText(expiryDate),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, String itemName) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "$itemName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Widget _buildItemCard(Item item, Box<Item> box) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: item.imagePath != null && item.imagePath!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(item.imagePath!),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.main.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FaIcon(
                          item.categoryType.toLowerCase() == 'grocery'
                              ? FontAwesomeIcons.box
                              : FontAwesomeIcons.capsules,
                          color: AppColors.main,
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.main.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FaIcon(
                    item.categoryType.toLowerCase() == 'grocery'
                        ? FontAwesomeIcons.box
                        : FontAwesomeIcons.capsules,
                    color: AppColors.main,
                  ),
                ),
          title: Row(
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
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    FontAwesomeIcons.layerGroup,
                    'Qty: ${item.quantity}',
                  ),
                  _buildInfoChip(
                    FontAwesomeIcons.tag,
                    item.categoryType,
                  ),
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
          trailing: IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              color: Colors.red,
              size: 20,
            ),
            onPressed: () async {
              if (await _confirmDelete(context, item.itemName)) {
                box.deleteAt(box.values.toList().indexOf(item));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.itemName} deleted'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        box.add(item);
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
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
            return daysLeft >= 0 && daysLeft <= 7;
          }
        }).toList();

        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  isExpired ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.bell,
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

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return _buildItemCard(item, box);
          },
        );
      },
    );
  }
}
