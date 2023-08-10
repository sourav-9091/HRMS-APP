// ignore: file_names
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GeneralTextField extends StatelessWidget {
  String text;
  TextEditingController textEditingController;
  Icon icon;
  TextInputType textInputType;
  GeneralTextField(
      {super.key,
      required this.text,
      required this.textInputType,
      required this.textEditingController,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black)),
        child: TextField(
          keyboardType: textInputType,
          decoration: InputDecoration(
            prefixIcon: icon,
            border: InputBorder.none,
            labelText: text,
            hintStyle: const TextStyle(color: Colors.black),
            labelStyle: const TextStyle(color: Colors.black),
          ),
          cursorColor: Colors.black,
          cursorHeight: 25,
          controller: textEditingController,
        ),
      ),
    );
  }
}
