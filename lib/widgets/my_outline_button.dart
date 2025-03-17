import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/custom_text_style.dart';



class MyOutlineButton extends StatefulWidget {
  String btnText;
  FontWeight? textWeight;
  Color? btnBackground;
  Color? btnTextColor;
  double? btnTextSize;
  VoidCallback onPressed;
  double? borderRadius;
  Color? borderColor ;
  MyOutlineButton(
      {super.key,
        this.btnBackground = Colors.white,
        required this.btnText,
        required this.onPressed,
        this.btnTextColor = Colors.black,
        this.textWeight = FontWeight.normal,
        this.btnTextSize = 18 ,
        this.borderRadius = 16 ,
        this.borderColor = AppColors.primary
      });

  @override
  State<MyOutlineButton> createState() => _MyFilledButtonState();
}

class _MyFilledButtonState extends State<MyOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: widget.btnBackground,
            side:  BorderSide(width: 2 , color: widget.borderColor!),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius!))),
        child: Text(
          widget.btnText,
          style: myTextStyle18(fontColor: widget.btnTextColor! , fontWeight: widget.textWeight! ),
        ));
  }
}
