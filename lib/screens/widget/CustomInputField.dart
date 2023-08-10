import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final Color primaryColor;
  final Color secondaryColor;
  final String hint;
  final TextInputType textInputType;
  Icon icon;

  CustomInputField({
    super.key,
    required this.textEditingController,
    required this.primaryColor,
    required this.secondaryColor,
    required this.hint,
    required this.textInputType,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: textEditingController,
      keyboardType: textInputType,
      style: TextStyle(
        color: secondaryColor,
        fontFamily: 'Raleway',
      ),
      cursorColor: secondaryColor,
      decoration: InputDecoration(
        prefixIcon: icon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        hintStyle: TextStyle(color: secondaryColor),
        hintText: hint,
        filled: true,
        fillColor: primaryColor,
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
