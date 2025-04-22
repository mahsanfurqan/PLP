import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomButtonAction extends StatelessWidget {
  final String text;
  final Color color;
  final Color shadowColor;
  final VoidCallback onPressed;
  final bool isPressed;
  final Color? borderColor;
  final Color? textColor;
  final double borderWidth;

  const CustomButtonAction({
    Key? key,
    required this.text,
    required this.color,
    required this.shadowColor,
    required this.onPressed,
    required this.isPressed,
    this.borderColor,
    this.textColor,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onPressed();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, isPressed ? 2 : 0, 0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          border:
              borderColor != null
                  ? Border.all(color: borderColor!, width: borderWidth)
                  : null,
          boxShadow:
              isPressed
                  ? []
                  : [
                    BoxShadow(
                      color: shadowColor,
                      offset: const Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
