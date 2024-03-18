import 'package:cryptosight/shared/utils/screen_config.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.labelText,
    this.initialValue,
    this.prefixIcon,
    this.onTap,
    this.onChanged,
  });

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? labelText;
  final String? initialValue;
  final IconData? prefixIcon;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
      readOnly: onTap != null,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.grey[900],
        filled: true,
        prefixIconConstraints: BoxConstraints(
          minWidth: ScreenConfig.scaledWidth(0.09),
        ),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                color: Colors.white,
                size: ScreenConfig.scaledWidth(0.05),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.4),
            width: 0.8,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.8),
            width: 0.8,
          ),
        ),
        contentPadding: ScreenConfig.symmetricDynamicPadding(0.02, 0.01),
      ),
    );
  }
}
