import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
  });
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;

  @override
  Widget build(context) {
    return TextFormField(
      decoration: InputDecoration(hintText: hintText),
      controller: controller,
      obscureText: isObscureText,
      validator: (val) {
        if (val!.trim().isEmpty) {
          print('Empty');
          return "$hintText is empty";
        }
      },
    );
  }
}
