import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartstock/utils/app_utils.dart';
import 'package:smartstock/utils/custom_text_style.dart';


class CustomWidgets{

  /// expiry badge
 static Widget expiryBadge(String expiryDate) {
    final daysLeft = AppUtils.getDaysLeft(expiryDate);
    if (daysLeft < 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.circleXmark,
              color: Colors.red,
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
                'Expired',
                style: myTextStyle12(fontColor: Colors.red , fontWeight: FontWeight.bold)
            ),

          ],
        ),
      );
    } else if (daysLeft == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.orange,
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
                'Expires Today',
                style: myTextStyle12(fontColor: Colors.orange , fontWeight: FontWeight.bold)
            ),
          ],
        ),
      );
    } else if (daysLeft == 1) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withAlpha(80)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.orange,
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              'Expires Tomorrow',
              style:myTextStyle12(fontWeight: FontWeight.bold , fontColor: Colors.orange) ,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
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