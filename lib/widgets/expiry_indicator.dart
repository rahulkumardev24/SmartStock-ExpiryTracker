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
      final expiry = DateFormat('dd MMM yyyy').parse(expiryDate);
      // Set both times to start of day for accurate comparison
      final now = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      final expiryDay = expiry.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      return expiryDay.difference(now).inDays;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = _getDaysLeft(expiryDate);
    
    // Calculate progress and color
    Color indicatorColor;
    double progress;
    
    if (daysLeft < 0) {
      // Expired
      indicatorColor = Colors.red;
      progress = 1.0;
    } else if (daysLeft == 0) {
      // Expires today
      indicatorColor = Colors.orange;
      progress = 0.9;
    } else if (daysLeft == 1) {
      // Expires tomorrow
      indicatorColor = Colors.orange.shade300;
      progress = 0.8;
    } else if (daysLeft <= 7) {
      // Expires within a week
      indicatorColor = Colors.yellow.shade700;
      progress = 0.6;
    } else if (daysLeft <= 30) {
      // Expires within a month
      indicatorColor = Colors.lightGreen;
      progress = 0.4;
    } else {
      // More than a month left
      indicatorColor = Colors.green;
      progress = 0.2;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.black26,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}
