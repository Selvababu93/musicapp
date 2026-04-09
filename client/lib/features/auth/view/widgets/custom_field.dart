import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({super.key, required this.hinttext});
  final String hinttext;

  @override
  Widget build(context) {
    return TextFormField(decoration: InputDecoration(hintText: hinttext));
  }
}
