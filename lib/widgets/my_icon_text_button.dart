import 'package:flutter/material.dart';

import '../utils/custom_text_style.dart';


class MyIconTextButton extends StatefulWidget {
  String btnText;
  FontWeight? textWeight;
  Color? btnBackground;
  Color? btnTextColor;
  double? btnTextSize;
  VoidCallback onPressed;
  double? borderRadius;
  String iconPath;
  MyIconTextButton(
      {super.key,
      this.btnBackground = Colors.white,
      required this.btnText,
      required this.onPressed,
      this.btnTextColor = Colors.black,
      this.textWeight = FontWeight.normal,
      this.btnTextSize = 18,
      this.borderRadius = 16,
      required this.iconPath});

  @override
  State<MyIconTextButton> createState() => _MyFilledButtonState();
}

class _MyFilledButtonState extends State<MyIconTextButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: widget.btnBackground,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius!))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.iconPath,
              height: 30,
            ),
            const SizedBox(width: 8,),
            Text(
              widget.btnText,
              style: myTextStyle18(
                  fontWeight: widget.textWeight!,
                  fontColor: widget.btnTextColor!),
            ),
          ],
        ));
  }
}
