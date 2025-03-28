import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartstock/utils/app_utils.dart';
import 'package:smartstock/utils/custom_text_style.dart';


class CustomWidgets{

  /// expiry badge
  static Widget expiryBadge(String expiryDate) {
    final daysLeft = AppUtils.getDaysLeft(expiryDate);
    String expiryText = AppUtils.getExpiryText(expiryDate);

    Color badgeColor;
    if (daysLeft < 0) {
      badgeColor = Colors.red;
    } else if (daysLeft <= 1) {
      badgeColor = Colors.orange;
    } else {
      badgeColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(40),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            daysLeft < 0
                ? FontAwesomeIcons.circleXmark
                : FontAwesomeIcons.triangleExclamation,
            color: badgeColor,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            expiryText,
            style: myTextStyle12(fontColor: badgeColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
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