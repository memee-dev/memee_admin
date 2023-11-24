import 'package:flutter/material.dart';
import 'package:memee_admin/ui/__shared/extensions/widget_extensions.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool readOnly;
  final double? width;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.readOnly = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: readOnly,
      obscureText: obscureText,
      controller: controller,
      style: Theme.of(context).textTheme.bodySmall,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodySmall,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
    ).sizedBoxW(width);
  }
}
