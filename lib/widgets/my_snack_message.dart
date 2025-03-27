import 'package:flutter/material.dart';

class MySnackMessage extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Duration duration;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final double fontSize;
  final Color messageColor;
  final Color labelTextColor ;
  final Color labelBackgroundColor ;

  const MySnackMessage({
    super.key,
    required this.message,
    this.actionLabel = '',
    this.onActionPressed,
    this.duration = const Duration(seconds: 3),
    this.backgroundColor = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.fontSize = 18,
    this.messageColor = Colors.white,
    this.labelTextColor = Colors.black54 ,
    this.labelBackgroundColor = Colors.white24
  });

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            color: messageColor,
            fontFamily: "primary"
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action:
            actionLabel!.isNotEmpty
                ? SnackBarAction(
              backgroundColor: labelBackgroundColor,
                  label: actionLabel!,
                  textColor: labelTextColor,
                  onPressed: onActionPressed ?? () {},
                )
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
