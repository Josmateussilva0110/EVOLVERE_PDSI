import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final IconData? icon;
  final String? Function(String?)? validator;
  final int? maxLength;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.icon,
    this.validator,
    this.maxLength,
     this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMultiline = maxLines > 1;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF222222),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          vertical: isMultiline ? 24 : 20,
          horizontal: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF007AFF), width: 2),
        ),
        counterStyle: const TextStyle(color: Colors.white54),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }
}
