import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'app_utils.dart';
import 'custom_text_style.dart';



class CustomWidgets{
  /// Expiry badge with better date handling
  static Widget expiryBadge(String expiryDate) {
    try {
      final daysLeft = AppUtils.getDaysLeft(expiryDate);
      String expiryText = AppUtils.getExpiryText(expiryDate);

      Color badgeColor;
      IconData icon;

      if (daysLeft < 0) {
        badgeColor = Colors.red;
        icon = FontAwesomeIcons.circleXmark;
      } else if (daysLeft == 0) {
        badgeColor = Colors.orange;
        icon = FontAwesomeIcons.circleExclamation;
      } else if (daysLeft <= 3) {
        badgeColor = Colors.orange;
        icon = FontAwesomeIcons.triangleExclamation;
      } else {
        badgeColor = Colors.green;
        icon = FontAwesomeIcons.circleCheck;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: badgeColor.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: badgeColor.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 12, color: badgeColor),
            const SizedBox(width: 4),
            Text(
              expiryText,
              style: myTextStyle12(
                fontColor: badgeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('Error creating expiry badge: $e');
      return const SizedBox(); // Fallback widget
    }
  }

  /// infoChip
  static Widget InfoChip(
      IconData icon,
      String label, {
        bool isExpiringSoon = false,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color : Colors.white60,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            icon,
            size: 12,
            color: Colors.black.withAlpha(170),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: myTextStyle12(fontColor:Colors.black.withAlpha(170)),

          ),
        ],
      ),
    );
  }


}