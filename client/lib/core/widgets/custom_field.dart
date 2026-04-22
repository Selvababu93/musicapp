import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.readOnly = false,
    this.onTap,
  });
  final String hintText;
  final TextEditingController? controller;
  final bool isObscureText;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(context) {
    return TextFormField(
      decoration: InputDecoration(hintText: hintText),
      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      obscureText: isObscureText,
      validator: (val) {
        if (val == null || val.isEmpty || val.length <= 2 || val.length > 50) {
          // print('Empty');
          return "$hintText must be valid";
        }
        return null;
      },
    );
  }
}
