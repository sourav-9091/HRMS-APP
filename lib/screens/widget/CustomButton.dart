import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final String text;
  VoidCallback? onPress;

  CustomElevatedButton({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onPress,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        textStyle: const TextStyle(fontSize: 16),
        fixedSize: const Size(500, 55),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: onPress,
      child: Text(
        ' $text ',
        style: const TextStyle(
          fontFamily:'Raleway',
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
