import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpiryIndicator extends StatelessWidget {
  final String expiryDate;

  const ExpiryIndicator({
    super.key,
    required this.expiryDate,
  });

  int _getDaysLeft(String expiryDate) {
    try {
      // Try multiple date formats
      DateTime expiry;

      if (expiryDate.contains('-')) {
        expiry = DateFormat('yyyy-MM-dd').parse(expiryDate);
      } else if (expiryDate.contains(' ')) {
        expiry = DateFormat('dd MMM yyyy').parse(expiryDate);
      } else {
        expiry = DateTime.parse(expiryDate);
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);

      return expiryDay.difference(today).inDays;
    } catch (e) {
      debugPrint('Error parsing expiry date: $e');
      return 0; // Default value if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = _getDaysLeft(expiryDate);

    // Calculate progress and color
    Color indicatorColor;
    double progress;
    String statusText;

    if (daysLeft < 0) {
      // Expired
      indicatorColor = Colors.red;
      progress = 1.0;
      statusText = 'Expired';
    } else if (daysLeft == 0) {
      // Expires today
      indicatorColor = Colors.orange;
      progress = 0.9;
      statusText = 'Expires Today';
    } else if (daysLeft == 1) {
      // Expires tomorrow
      indicatorColor = Colors.orange.shade300;
      progress = 0.8;
      statusText = 'Expires Tomorrow';
    } else if (daysLeft <= 7) {
      // Expires within a week
      indicatorColor = Colors.yellow.shade700;
      progress = 0.6;
      statusText = 'Expires in $daysLeft days';
    } else if (daysLeft <= 30) {
      // Expires within a month
      indicatorColor = Colors.lightGreen;
      progress = 0.4;
      statusText = 'Expires in $daysLeft days';
    } else {
      // More than a month left
      indicatorColor = Colors.green;
      progress = 0.2;
      statusText = 'Expires in $daysLeft days';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey.shade300,
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
        minHeight: 5,
      ),
    );
  }
}