import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final TextInputType keyboard;
  final String? Function(String?)? validator;

  const InputField({
    required this.controller,
    required this.label,
    this.obscure = false,
    this.keyboard = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: obscure,
      keyboardType: keyboard,
      validator: validator,
    );
  }
}
