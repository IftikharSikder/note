import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? obscureText;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.validator,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
