import 'package:flutter/material.dart';


import '../utils/colors.dart';
import '../utils/custom_text_style.dart';

class SlidingButton extends StatefulWidget {
  final VoidCallback onComplete;
  const SlidingButton({required this.onComplete, Key? key}) : super(key: key);

  @override
  _SlidingButtonState createState() => _SlidingButtonState();
}

class _SlidingButtonState extends State<SlidingButton> {
  double _position = 0.0;
  final double _maxPosition = 200.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Track
        Container(
          width: _maxPosition + 60,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.main.withAlpha(100)
            ,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            "Slide to Start",
            style: myTextStyle18(fontWeight: FontWeight.bold),
          ),
        ),

        // Sliding Button
        Positioned(
          left: _position,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _position += details.delta.dx;
                if (_position < 0) _position = 0;
                if (_position > _maxPosition) _position = _maxPosition;
              });
            },
            onHorizontalDragEnd: (details) {
              if (_position >= _maxPosition) {
                widget.onComplete();
              }
              setState(() {
                _position = 0;
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.main,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 2),
                ],
              ),
              child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
