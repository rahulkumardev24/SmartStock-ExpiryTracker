import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/my_filled_button.dart';
import '../widgets/my_outline_button.dart';
import 'colors.dart';
import 'custom_text_style.dart';

class AppUtils {
  /// delete alert message
  static Future<bool> confirmDelete(
    BuildContext context,
    String itemName,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Confirm Delete',
                style: myTextStyle18(fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Are you sure you want to delete "$itemName"?',
                style: myTextStyle12(),
              ),
              backgroundColor: AppColors.primary,
              actions: [
                MyOutlineButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  btnText: 'Cancel',
                  borderColor: Colors.black45,
                  borderRadius: 21,
                  btnTextColor: Colors.black45,
                  btnBackground: Colors.transparent,
                ),
                MyFilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  btnText: 'Delete',
                  btnTextColor: Colors.white,
                  btnBackground: Colors.red,
                  borderRadius: 21,
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// how many date left
  static int getDaysLeft(String expiryDate) {
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

  /// Get expiry text
  static String getExpiryText(String expiryDate) {
    final daysLeft = getDaysLeft(expiryDate);
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

  static bool isExpiringSoon(String expiryDate) {
    final daysLeft = getDaysLeft(expiryDate);
    return daysLeft >= 0 && daysLeft <= 30;
  }

}
