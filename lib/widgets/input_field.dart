import 'package:flutter/material.dart';
import 'package:seventy_five_hard/Utils/utils.dart';

class InputField extends StatelessWidget {
  final String label;
  final bool isPasswordField;
  final TextEditingController controller;
  final FocusNode? focusNode; // Add FocusNode support

  const InputField({
    super.key,
    required this.label,
    required this.controller,
    required this.isPasswordField,
    this.focusNode, // Accept FocusNode as an optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPasswordField,
      focusNode: focusNode, // Attach the FocusNode
      cursorColor: AppColors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.white),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 2, color: AppColors.primaryColor),
        ),
      ),
      onTap: () {
        // Debug log for interaction
        print('$label field tapped');
      },
    );
  }
}
