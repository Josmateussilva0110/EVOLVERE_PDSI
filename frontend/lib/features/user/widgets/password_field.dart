import 'package:flutter/material.dart';

class CustomPasswordField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final VoidCallback toggle;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomPasswordField({
    super.key,
    required this.label,
    required this.obscureText,
    required this.toggle,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: isLightMode ? Colors.black87 : Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isLightMode ? Colors.black54 : Colors.white70,
        ),
        filled: true,
        fillColor: isLightMode ? Colors.grey.shade50 : const Color(0xFF2C2C2C),
        prefixIcon: Icon(
          Icons.lock,
          color: isLightMode ? Colors.black54 : Colors.white70,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: isLightMode ? Colors.black54 : Colors.white70,
          ),
          onPressed: toggle,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isLightMode ? Colors.blue : const Color(0xFF2196F3),
            width: 2,
          ),
        ),
      ),
    );
  }
}
